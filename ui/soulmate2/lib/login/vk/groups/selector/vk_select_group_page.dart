import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/view/images_list.dart';
import 'package:soulmate2/login/vk/auth/bloc/vk_auth_bloc.dart';
import 'package:soulmate2/login/vk/groups/photo_feed/vk_group_feed.dart';
import 'package:soulmate2/login/vk/groups/selector/bloc/vk_groups_bloc.dart';

class VkSelectGroupList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) =>
            VkGroupsBloc(context.read<VkAuthBloc>().state as VkAuthSucceededState)..add(VkFetchGroupsEvent()),
        child: BlocConsumer<VkGroupsBloc, VkGroupsState>(listener: (context, state) {
          if (state is VkGroupsFetchErrorState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Error:${state.error}')));
          }
        }, builder: (context, state) {
          // return Text("hello");
          if (!(state is VkGroupsFetchedState)) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.groups.length == 0) {
            return Center(child: Text("No groups"));
          }
          return ListView.builder(
            itemCount: state.groups.length,
            itemBuilder: (context, index) {
              var group = state.groups[index];

              return ListTile(
                title: Text(group.name),
                // minLeadingWidth: 60,
                // minVerticalPadding: 0,
                leading: ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: group.previewUrl,
                    width: 50,
                    height: 50),
                ),
                onTap: () => Navigator.of(context).push(VkGroupFeed.route(group.id)),
              );
              return Expanded(
                child: SizedBox(
                  height: 20,
                  child: ListTile(
                    title: Text(group.name),
                    leading: CachedNetworkImage(imageUrl: group.previewUrl),
                    onTap: () => Navigator.of(context).push(VkGroupFeed.route(group.id)),
                  ),
                ),
              );
            },
          );
        }));
  }
}
