import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';
import 'package:soulmate2/images/view/images_list.dart';
import 'package:soulmate2/images/view/images_list_item.dart';

class FavoritesImagesBloc extends ImagesBloc {
  FavoritesImagesBloc(FavoriteImagesRepository imagesRepository) : super(imagesRepository, false);
}

class FavoritesPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => FavoritesPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => FavoritesImagesBloc(FavoriteImagesRepository(context.read<LikesBloc>()))..add(FetchImages()))
        ],
        child: CustomImagesList<FavoritesImagesBloc>(
          fetchImages: (bloc) => bloc.add(FetchImages()),
          getItems: (state) => state.images,
          builder: (context, index) => ImageListItem<FavoritesImagesBloc>(index: index,),
          getErrorMessage: (state) => null,
        ),
      ),
    );
  }
}
