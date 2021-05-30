import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:soulmate2/images/models/image.dart';

class FavoritesCache {
  final Set<ImageModel> _cache;

  FavoritesCache(this._cache);

  Iterable<ImageModel> get images => _cache;

  bool isFavorite(ImageModel image) => _cache.contains(image);

  bool remove(ImageModel image) => _cache.remove(image);

  bool add(ImageModel image) => _cache.add(image);
}

class FavoritesRepository {
  static const String LOCAL_FAVORITES = 'local-favorites';

  static String _createUserFavorites(String uid) => 'user-favorites-$uid';

  final FirebaseDatabase _database;

  DatabaseReference? _favorites;

  FavoritesCache? _cache;

  final StreamController<FavoritesCache> _controller = StreamController();
  final List<StreamSubscription> _listeners = [];

  FavoritesRepository(this._database){
    setFavorites();
  }

  void _createListeners(String sourceType) {
    _listeners.forEach((x) => x.cancel());
    _listeners.clear();

    final addListener = _favorites!.child(sourceType).onChildAdded.listen((event) {
      final image = ImageModel(
          id: event.snapshot.key as String, sourceType: sourceType, url: event.snapshot.value['url'] as String);
      print('$sourceType favorite added: ${image.url}');
      if (_cache != null) {
        _cache!.add(image);
        _controller.add(_cache!);
      }
    });

    final removeListener = _favorites!.child(sourceType).onChildRemoved.listen((event) {
      final image = ImageModel(
          id: event.snapshot.key as String, sourceType: sourceType, url: event.snapshot.value['url'] as String);
      print('$sourceType favorite url removed: ${image.url}');
      if (_cache != null) {
        _cache!.remove(image);
        _controller.add(_cache!);
      }
    });

    _listeners.addAll([addListener, removeListener]);
  }

  Stream<FavoritesCache> get favorites => _controller.stream;

  Future<void> addFavorite(ImageModel image) async {
    return await _favorites!
        .child(image.sourceType)
        .child(image.id)
        .set({'url': image.url})
        .timeout(Duration(seconds: 1))
        .catchError((e) => print("Error saving favorite:$e"));
  }

  Future<void> removeFavorite(ImageModel image) async {
    return await _favorites!.child(image.sourceType).child(image.id).remove();
  }

  Future<bool> isFavorite(ImageModel image) async {
    return await _favorites!.child(image.sourceType).child(image.id).once().then((snapshot) => snapshot.value != null);
  }

  Future<void> loadFavorites() async {
    return await _favorites!
        .once()
        // .timeout(Duration(seconds: 2))
        .then((value) => _cache = FavoritesCache(_buildImageModelsFromStorageModel(value)))
        .then((value) => _createListeners('vk'))
        .then((value) => _controller.add(_cache!))
        .catchError((e) => print('Error loading favorites: $e'));
  }

  Set<ImageModel> _buildImageModelsFromStorageModel(DataSnapshot value) {
    final images = Set<ImageModel>();
    if (value.value == null) return images;
    var sourceTypes = value.value as Map;
    sourceTypes.forEach((sourceType, value) {
      var imageIds = sourceTypes[sourceType] as Map;
      imageIds.forEach((id, value) {
        images.add(ImageModel(id: id as String, sourceType: sourceType as String, url: value['url'] as String));
      });
    });
    return images;
  }

  Future<void> transferDataToUser(String uid) async {
    var currentData = await _favorites!.once().timeout(Duration(seconds: 2));

    var newFavorites = _database.reference().child(_createUserFavorites(uid));
    await newFavorites.set(currentData);
    await _favorites!.remove();
    newFavorites.keepSynced(true);
  }

  void setFavorites()  {
    var user = FirebaseAuth.instance.currentUser;
    final favoritesPath = user == null ? LOCAL_FAVORITES : _createUserFavorites(user.uid);
    _favorites = _database.reference().child(favoritesPath);
    _favorites!.keepSynced(true);
  }
}
