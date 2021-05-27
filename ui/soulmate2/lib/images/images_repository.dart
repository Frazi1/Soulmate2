import 'dart:async';
import 'dart:convert';

import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';
import 'package:soulmate2/images/models/image.dart';
import 'package:http/http.dart' as http;

abstract class ImagesRepository {
  Future<List<ImageModel>> fetchImages([int startIndex = 0, int limit = 5]);
  Future<void> close();
}

class FavoriteImagesRepository extends ImagesRepository {
  Map<String, bool> _favorites;

  late final StreamSubscription favoritesUpdatesSub;

  FavoriteImagesRepository(LikesBloc likesBloc) : _favorites = likesBloc.state.likedUrls {
    favoritesUpdatesSub = likesBloc.stream.listen((event) {
      _favorites = event.likedUrls;
    });
  }

  @override
  Future<List<ImageModel>> fetchImages([int startIndex = 0, int limit = 5]) {
    var result = _favorites.entries
        .where((element) => element.value == true)
        .skip(startIndex)
        .take(limit)
        .map((e) => ImageModel(e.key))
        .toList();

    return Future.value(result);
  }

  @override
  Future<void> close() {
    return favoritesUpdatesSub.cancel();
  }
}

class TestingImagesRepository extends ImagesRepository {
  @override
  Future<List<ImageModel>> fetchImages([int startIndex = 0, int limit = 5]) async {
    final response = await http.get(
      Uri.https(
        'jsonplaceholder.typicode.com',
        '/photos',
        <String, String>{'_start': '$startIndex', '_limit': '$limit'},
      ),
    );
    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;
      return body.map((dynamic json) {
        return ImageModel(json['url'] as String);
      }).toList();
    }
    throw Exception('error fetching images: ${response.statusCode}');
  }

  @override
  Future<void> close() {
    return Future.value(null);
  }
}
