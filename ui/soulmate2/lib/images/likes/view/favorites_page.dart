import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';
import 'package:soulmate2/images/view/images_list.dart';
import 'package:soulmate2/images/view/images_list_item.dart';

class FavoritesImagesBloc extends ImagesBloc {
  late final StreamSubscription _likesSub;

  FavoritesImagesBloc(FavoriteImagesRepository imagesRepository, LikesBloc likesBloc) : super(imagesRepository) {
    _likesSub = likesBloc.stream.listen((state) {
      if (state is FavoritesLoadedState) {
        add(FetchImages());
      }
    });
  }

  @override
  Future<void> close() async {
    await _likesSub.cancel();
    return await super.close();
  }
}

class FavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) {
            var likesBloc = context.read<LikesBloc>();
            likesBloc.add(LoadFavoritesEvent());
            return FavoritesImagesBloc(FavoriteImagesRepository(likesBloc), likesBloc)..add(FetchImages());
          })
        ],
        child: CustomImagesList<FavoritesImagesBloc>(
          fetchImages: (bloc) => bloc.add(FetchImages()),
          getItems: (state) => state.images,
          builder: (context, index) => ImageListItem<FavoritesImagesBloc>(
            index: index,
          ),
          getErrorMessage: (state) => null,
        ),
      ),
    );
  }
}
