import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';

class ImageListItem extends StatelessWidget {
  final int index;

  const ImageListItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesBloc, ImagesState>(
      builder: (context, state) {
        final currentImage = state.images[index];
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
                child: BlocBuilder<LikesBloc, LikesState>(
                  builder: (context, state) {
                    var liked =
                        state.likedUrls.containsKey(currentImage.url) && state.likedUrls[currentImage.url] == true;
                    return GestureDetector(
                      child: Icon(Icons.favorite, color: liked ? Colors.red : Colors.grey),
                      onTap: () => context.read<LikesBloc>().add(ToggleLikeEvent(currentImage.url, !liked)),
                    );
                  },
                )),
          ],
        );
      },
    );
  }
}
