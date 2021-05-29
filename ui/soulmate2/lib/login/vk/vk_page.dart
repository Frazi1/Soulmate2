import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/login/vk/auth/bloc/vk_auth_bloc.dart';
import 'package:soulmate2/login/vk/groups/selector/vk_select_group_page.dart';
import 'package:soulmate2/login/vk/profile/vk_profile_page.dart';

import '../../soulmate_drawer.dart';

class VkPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => VkPage());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VkAuthBloc, VkAuthState>(
      builder: (context, state) {
        var isLoggedIn = state is VkAuthSucceededState;

        int length = isLoggedIn ? 2 : 1;
        var tabs = [Tab(icon: Icon(Icons.account_circle))];
        var views = <Widget>[VkProfilePage()];
        if (isLoggedIn) {
          tabs.add(Tab(icon: Icon(Icons.photo)));
          views.add(VkSelectGroupList());
        }
        return DefaultTabController(
            length: length,
            child: Scaffold(
              drawer: SoulmateDrawer(),
              appBar: TabBar(tabs: tabs),
              body: TabBarView(
                children: views,
              ),
            ));
      },
    );
  }
}
