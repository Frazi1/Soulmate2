import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/auth/vk/auth/bloc/vk_auth_bloc.dart';
import 'package:soulmate2/auth/vk/auth/vk_auth_page.dart';

class VkProfilePage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => VkProfilePage());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VkAuthBloc, VkAuthState>(
      builder: (context, state) {
        if (state is VkAuthSucceededState) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      state.avaUrl != null
                          ? ClipOval(child: CachedNetworkImage(imageUrl: state.avaUrl!))
                          : Text(""),
                      Padding(padding: EdgeInsets.all(4)),
                      Text(state.displayName),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.read<VkAuthBloc>().add(VkAuthLogoutEvent()),
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Center(
          child: ElevatedButton(
            child: const Text('Login into VK'),
            onPressed: () async {
              await Navigator.of(context).push(VkAuthPage.route());
            },
          ),
        );
      },
    );
  }
}
