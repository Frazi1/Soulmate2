import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/auth/vk/auth/bloc/vk_auth_bloc.dart';
import 'package:soulmate2/auth/vk/groups/photo_feed/vk_group_photos_feed_bloc.dart';
import 'package:soulmate2/auth/vk/groups/photo_feed/vk_group_photos_repository.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/view/images_list.dart';
import 'package:soulmate2/images/view/images_list_item.dart';

class VkGroupFeed extends StatelessWidget {
  static Route route(String groupId) => MaterialPageRoute<void>(builder: (_) => VkGroupFeed(groupId));

  final String groupId;

  VkGroupFeed(this.groupId);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VkGroupPhotosFeedBloc(
          groupId, VkGroupImagesRepository(context.read<VkAuthBloc>().state as VkAuthSucceededState, groupId))
        ..add(FetchImages()),
      child: Scaffold(
        body: BlocBuilder<VkGroupPhotosFeedBloc, ImagesState>(builder: (context, state) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              final maxScroll = notification.metrics.maxScrollExtent;
              final currentScroll = notification.metrics.extentBefore;

              if (currentScroll > maxScroll * 0.8) {
                context.read<VkGroupPhotosFeedBloc>().add(FetchImages());
              }

              return false;
            },
            child: Scrollbar(
              child: CustomScrollView(slivers: [
                SliverAppBar(
                  floating: true,
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => ImageListItem<VkGroupPhotosFeedBloc>(index: index),
                      childCount: state.images.length),
                ),
              ]),
            ),
          );
        }),
      ),
    );
  }
}
