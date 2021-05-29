import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/login/vk/auth/bloc/vk_auth_bloc.dart';
import 'package:soulmate2/login/vk/auth/vk_auth_page.dart';

class VkProfilePage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => VkProfilePage());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VkAuthBloc, VkAuthState>(
      builder: (context, state) {
        if (state is VkAuthSucceededState) {
          return Stack(children: <Widget>[
            Text("Logged in as ${state.userId}"),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: () => context.read<VkAuthBloc>().add(VkAuthLogoutEvent()),
                child: const Text("Logout"),
              ),
            )
          ]);
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
