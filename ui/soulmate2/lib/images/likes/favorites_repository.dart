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
  final FirebaseDatabase _database;
  late final DatabaseReference _favorites;

  FavoritesCache? _cache;

  final StreamController<FavoritesCache> _controller = StreamController();

  FavoritesRepository(this._database) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    _favorites = _database.reference().child('user-favorites-$uid');
    _favorites.keepSynced(true);
  }

  void createListeners(String sourceType) {
    _favorites.child(sourceType).onChildAdded.listen((event) {
      final image = ImageModel(
          id: event.snapshot.key as String, sourceType: sourceType, url: event.snapshot.value['url'] as String);
      print('$sourceType favorite added: ${image.url}');
      if (_cache != null) {
        _cache!.add(image);
        _controller.add(_cache!);
      }
    });
    _favorites.child(sourceType).onChildRemoved.listen((event) {
      final image = ImageModel(
          id: event.snapshot.key as String, sourceType: sourceType, url: event.snapshot.value['url'] as String);
      print('$sourceType favorite url removed: ${image.url}');
      if (_cache != null) {
        _cache!.remove(image);
        _controller.add(_cache!);
      }
    });
  }

  Stream<FavoritesCache> get favorites => _controller.stream;

  Future<void> addFavorite(ImageModel image) async {
    return await _favorites
        .child(image.sourceType)
        .child(image.id)
        .set({'url': image.url})
        .timeout(Duration(seconds: 1))
        .catchError((e) => print("Error saving favorite:$e"));
  }

  Future<void> removeFavorite(ImageModel image) async {
    return await _favorites.child(image.sourceType).child(image.id).remove();
  }

  Future<bool> isFavorite(ImageModel image) async {
    return await _favorites.child(image.sourceType).child(image.id).once().then((snapshot) => snapshot.value != null);
  }

  Future<void> loadFavorites() async {
    return await _favorites
        .once()
        // .timeout(Duration(seconds: 2))
        .then((value) => _cache = FavoritesCache(buildImageModelsFromStorageModel(value)))
        .then((value) => createListeners('vk'))
        .then((value) => _controller.add(_cache!))
        .catchError((e) => print('Error loading favorites: $e'));
  }

  Set<ImageModel> buildImageModelsFromStorageModel(DataSnapshot value) {
    final images = Set<ImageModel>();

    var sourceTypes = value.value as Map;
    sourceTypes.forEach((sourceType, value) {
      var imageIds = sourceTypes[sourceType] as Map;
      imageIds.forEach((id, value) {
        images.add(ImageModel(id: id as String, sourceType: sourceType as String, url: value['url'] as String));
      });
    });
    return images;
  }
}
