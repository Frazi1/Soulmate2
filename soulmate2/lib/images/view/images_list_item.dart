import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/likes/bloc/favorites_bloc.dart';
import 'package:soulmate2/images/models/image.dart';

class ImageListItem extends StatelessWidget {
  final int index;
  final List<ImageModel> list;

  const ImageListItem({Key? key, required this.index, required this.list}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentImage = list[index];
    return Stack(
      children: <Widget>[
        Container(
          child: CachedNetworkImage(
            imageUrl: currentImage.url,
            errorWidget: (context, url, error) => Container(),
          ),
        ),
        Positioned(
            bottom: 30,
            right: 50,
            child: BlocBuilder<FavoritesBloc, FavoritesState>(
              builder: (context, state) {
                var liked = state is FavoritesLoadedState && state.cache.isFavorite(currentImage);
                return GestureDetector(
                  child: Icon(Icons.favorite, color: liked ? Colors.red : Colors.grey),
                  onTap: () {
                    var bloc = context.read<FavoritesBloc>();
                    bloc.add(ToggleFavoriteEvent(currentImage, !liked));
                  },
                );
              },
            )),
      ],
    );
  }
}