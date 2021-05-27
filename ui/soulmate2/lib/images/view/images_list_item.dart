import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/models/image.dart';

class ImageListItem extends StatelessWidget {
  // final ImageModel image;
  final int index;

  const ImageListItem({
    Key? key,
    required this.index,
    // required this.image,
  }) : super(key: key);

  ImageModel _getCurrentImage(ImagesState state) => state.images[index];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          child: BlocBuilder<ImagesBloc, ImagesState>(
            buildWhen: (previous, current) => _getCurrentImage(current).id != _getCurrentImage(previous).id,
            builder: (context, state) => CachedNetworkImage(
              imageUrl: _getCurrentImage(state).url,
              errorWidget: (context, url, error) {
                return Container();
              },
            ),
          ),
        ),
        Positioned(
            bottom: 30,
            right: 50,
            child: BlocBuilder<ImagesBloc, ImagesState>(
              builder: (context, state) {
                return GestureDetector(
                  child: Icon(Icons.favorite, color: _getCurrentImage(state).liked ? Colors.red : Colors.grey),
                  onTap: () => context.read<ImagesBloc>().add(ToggleImageLike(index)),
                );
              },
            )),
      ],
    );
  }
}
