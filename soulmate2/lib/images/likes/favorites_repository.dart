import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:soulmate2/images/models/image.dart';

class FavoritesCache {
  final Set<ImageModel> _cache;

  FavoritesCache(this._cache);

  Iterable<ImageModel> get images => _cache;

  bool isFavorite(ImageModel image) => _cache.contains(image);

  bool remove(ImageModel image) => _cache.remove(image);

  bool add(ImageModel image) => _cache.add(image);
}

class FavoritesChangeNotification {
  final FavoritesCache cache;
  final List<ImageModel> added;
  final List<ImageModel> deleted;

  FavoritesChangeNotification({required this.cache, this.added = const [], this.deleted = const[]});
}

class FavoritesRepository {
  static const String LOCAL_FAVORITES = 'local-favorites';

  static String _createUserFavorites(String uid) => 'user-favorites-$uid';

  final FirebaseDatabase _database;

  DatabaseReference? _favorites;
  FavoritesCache _cache = FavoritesCache(Set.of([]));

  Duration get _operationTimeout => Duration(milliseconds: 30);

  final StreamController<FavoritesChangeNotification> _controller = StreamController.broadcast();
  final Map<String, List<StreamSubscription>> _listeners = {};

  FavoritesRepository(this._database) {
    setFavorites();
  }

  Stream<FavoritesChangeNotification> get favorites => _controller.stream;

  void _clearListeners() {
    _listeners.forEach((key, value) => value.forEach((x) => x.cancel()));
    _listeners.clear();
  }

  void _createListeners() {
    // ignore: cancel_subscriptions
    final addListener = _favorites!.onChildAdded.listen((event) {
      final value = event.snapshot.value;
      final image = ImageModel(
        id: value['id'] as String,
        sourceType: value['source_type'] as String,
        url: value['url'] as String,
      );
      print('${image.sourceType} favorite added: ${image.url}');
      if (_cache != null) {
        _cache.add(image);
        _controller.add(FavoritesChangeNotification(cache: _cache, added: [image]));
      } else {
        print('Favorites cache is not initialized yet!');
      }
    });

    // ignore: cancel_subscriptions
    final removeListener = _favorites!.onChildRemoved.listen((event) {
      final value = event.snapshot.value;
      final image = ImageModel(
        id: value['id'] as String,
        sourceType: value['source_type'] as String,
        url: value['url'] as String,
      );
      print('${image.sourceType} favorite url removed: ${image.url}');
      if (_cache != null) {
        _cache.remove(image);
        _controller.add(FavoritesChangeNotification(cache: _cache, deleted: [image]));
      }
    });

    _listeners[""] = [addListener, removeListener];
  }


  Future<void> addFavorite(ImageModel image) async {
    return await _favorites!
        .child(createImageKey(image))
        .set(
          {'url': image.url, 'source_type': image.sourceType, 'id': image.id},
          priority: -DateTime.now().toUtc().millisecondsSinceEpoch,
        )
        .timeout(_operationTimeout, onTimeout: () => print('$_operationTimeout timeout expired when saving favorite'))
        .catchError((e) => print("Error saving favorite:$e"));
  }

  String createImageKey(ImageModel image) => '${image.sourceType}_${image.id}';

  Future<void> removeFavorite(ImageModel image) async {
    return await _favorites!.child(createImageKey(image)).remove().timeout(_operationTimeout,
        onTimeout: () => print('$_operationTimeout timeout expired when removing favorite'));
  }

  Future<FavoritesCache> loadFavorites() async {
    return await _favorites!
        .orderByPriority()
        .once()
        .timeout(_operationTimeout)
        .then((value) => _cache = FavoritesCache(_buildImageModelsFromStorageModel(value)))
        // .then((value) => _controller.add(_cache!))
        // .then((_) => print('Favorites cache initialized!'))
        .catchError((e) => print('Error loading favorites: $e'));
  }

  Set<ImageModel> _buildImageModelsFromStorageModel(DataSnapshot value) {
    final images = Set<ImageModel>();
    if (value.value == null) return images;
    var collection = value.value as Map;
    collection.forEach((key, image) {
      images.add(ImageModel(
        id: image['id'] as String,
        sourceType: image['source_type'] as String,
        url: image['url'] as String,
      ));
    });
    return images;
  }

  Future<void> transferDataToUser(String uid) async {
    final currentData = await _favorites!.once().timeout(Duration(seconds: 2)).catchError((e) {
      print('Error when loading existing local data: $e');
      return e;
    });

    if (currentData.value == null) {
      print('No favorites to migrate');
      return Future.value(null);
    }

    final newFavorites = _database.reference().child(_createUserFavorites(uid));
    await newFavorites
        .set(currentData.value)
        .timeout(_operationTimeout)
        .catchError((e) => print('Timeout $_operationTimeout expired when migrating favorites'));
    await _favorites!
        .remove()
        .timeout(_operationTimeout)
        .catchError((e) => print('Timeout $_operationTimeout expired when deleting local favorites'));
    newFavorites.keepSynced(true);
  }

  void setFavorites() {
    final user = FirebaseAuth.instance.currentUser;
    final favoritesPath = user == null ? LOCAL_FAVORITES : _createUserFavorites(user.uid);

    _favorites = _database.reference().child(favoritesPath);
    _clearListeners();
    _createListeners();
    _favorites!.keepSynced(true);
  }
}
