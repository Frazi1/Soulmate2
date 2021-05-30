import 'dart:async';
import 'dart:convert';

import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';
import 'package:soulmate2/images/models/image.dart';
import 'package:http/http.dart' as http;

import 'likes/favorites_repository.dart';

abstract class ImagesRepository {
  Future<List<ImageModel>> fetchImages([int startIndex = 0, int limit = 100]);
  Future<void> close();
}

class FavoriteImagesRepository extends ImagesRepository {
  late final StreamSubscription favoritesUpdatesSub;

  List<ImageModel>? _favorites;

  FavoriteImagesRepository(LikesBloc likesBloc) {
    updateFavorites(likesBloc.state);
    favoritesUpdatesSub = likesBloc.stream.listen((state) {
      updateFavorites(state);
    });
  }

  void updateFavorites(FavoritesState state) {
    if(state is FavoritesLoadedState){
      _favorites = state.favorites.images.toList();
    }
  }

  @override
  Future<List<ImageModel>> fetchImages([int startIndex = 0, int limit = 100]) {
    var result = _favorites
        ?.skip(startIndex)
        .take(limit)
        .toList()
    ?? [];

    return Future.value(result);
  }

  @override
  Future<void> close() {
    return favoritesUpdatesSub.cancel();
  }
}

// class TestingImagesRepository extends ImagesRepository {
//   @override
//   Future<List<ImageModel>> fetchImages([int startIndex = 0, int limit = 5]) async {
//     final response = await http.get(
//       Uri.https(
//         'jsonplaceholder.typicode.com',
//         '/photos',
//         <String, String>{'_start': '$startIndex', '_limit': '$limit'},
//       ),
//     );
//     if (response.statusCode == 200) {
//       final body = json.decode(response.body) as List;
//       return body.map((dynamic json) {
//         return ImageModel(json['url'] as String);
//       }).toList();
//     }
//     throw Exception('error fetching images: ${response.statusCode}');
//   }

//   @override
//   Future<void> close() {
//     return Future.value(null);
//   }
// }
