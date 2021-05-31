import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';
import 'package:soulmate2/favorites/upload/favorites_upload_cubit.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';
import 'package:soulmate2/images/view/images_list_item.dart';

class FavoritesImagesBloc extends ImagesBloc {
  late final StreamSubscription _likesSub;

  FavoritesImagesBloc(FavoriteImagesRepository imagesRepository, LikesBloc likesBloc)
      : super(imagesRepository, reverseList: true) {
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
          }),
        ],
        child: Scrollbar(
          child: BlocConsumer<FavoritesImagesBloc, ImagesState>(
            builder: (context, state) {
              var items = state.images;

              return CustomScrollView(slivers: [
                SliverAppBar(
                  floating: true,
                  title: Align(
                    alignment: Alignment.topRight,
                    child: BlocBuilder<FirebaseAuthBloc, FirebaseAuthState>(
                      builder: (context, state) {
                        if (state is! FirebaseAuthCompleted) {
                          return Row();
                        }
                        return IconButton(
                          icon: Icon(Icons.add_a_photo),
                          onPressed: () async {
                            final file = await ImagePicker().getImage(source: ImageSource.gallery);
                            if (file != null) {
                              context.read<FavoritesUploadCubit>().uploadImage(file.path);
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
                SliverList(
                  delegate: items.list.length == 0
                      ? SliverChildListDelegate(
                          [
                            Container(
                              margin: EdgeInsets.all(24),
                              child: Center(
                                child: state.status == ImagesStatus.loading
                                    ? CircularProgressIndicator()
                                    : Text('No items'),
                              ),
                            ),
                          ],
                        )
                      : SliverChildBuilderDelegate(
                          (context, index) => ImageListItem<FavoritesImagesBloc>(index: index),
                          childCount: items.list.length,
                        ),
                )
              ]);
            },
            listener: (context, state) {
              if (state.status == ImagesStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text("Could not load")));
              }
            },
          ),
        ),
      ),
    );
  }
}