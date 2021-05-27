import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';
import 'package:soulmate2/images/view/images_list.dart';

class FavoritesPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => FavoritesPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ImagesBloc(FavoriteImagesRepository(context.read<LikesBloc>()), false)..add(FetchImages()))
        ],
        child: ImagesList(),
      ),
    );
  }
}
