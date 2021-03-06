
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';
import 'package:soulmate2/favorites/upload/favorites_upload_cubit.dart';
import 'package:soulmate2/favorites/bloc/favorites_bloc.dart';
import 'package:soulmate2/images/view/images_list_item.dart';

class FavoritesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Scrollbar(
      child: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          SliverChildDelegate? body;
          if (state is FavoritesLoadedState && state.favorites.isNotEmpty) {
            body = SliverChildBuilderDelegate(
              (context, index) => ImageListItem(
                index: index,
                list: state.favorites,
              ),
              childCount: state.favorites.length,
            );
          } else {
            body = SliverChildListDelegate([
              Container(
                margin: EdgeInsets.all(24),
                child: Center(
                  child: state is FavoritesLoadedState ? Text('No favorites yet') : CircularProgressIndicator(),
                ),
              ),
            ]);
          }

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
            SliverList(delegate: body)
          ]);
        },
      ),
    ));
  }
}
