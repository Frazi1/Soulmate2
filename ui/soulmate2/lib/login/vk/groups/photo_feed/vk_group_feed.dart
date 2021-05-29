import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/view/images_list.dart';
import 'package:soulmate2/images/view/images_list_item.dart';
import 'package:soulmate2/login/vk/auth/bloc/vk_auth_bloc.dart';
import 'package:soulmate2/login/vk/groups/photo_feed/vk_group_photos_feed_bloc.dart';
import 'package:soulmate2/login/vk/groups/photo_feed/vk_group_photos_repository.dart';

class VkGroupFeed extends StatelessWidget {
  static Route route(String groupId) => MaterialPageRoute<void>(builder: (_) => VkGroupFeed(groupId));

  final String groupId;

  VkGroupFeed(this.groupId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => VkGroupPhotosFeedBloc(groupId, VkGroupImagesRepository(context.read<VkAuthBloc>().state as VkAuthSucceededState, groupId))..add(FetchImages()),
        child: Scaffold(
          body: CustomImagesList<VkGroupPhotosFeedBloc>(
              builder: (context, index) => ImageListItem<VkGroupPhotosFeedBloc>(index: index),
              getItems: (state) => state.images,
              fetchImages: (bloc) => bloc.add(FetchImages()),
              getErrorMessage: (state) => null),
        ));
  }
}
