import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/vk/profile/vk_profile_page.dart';

import '../../soulmate_drawer.dart';
import 'auth/bloc/vk_auth_bloc.dart';
import 'groups/selector/vk_select_group_page.dart';

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
          tabs.insert(0, Tab(icon: Icon(Icons.photo)));
          views.insert(0, VkSelectGroupList());
        }
        return DefaultTabController(
            length: length,
            child: Scaffold(
              appBar: AppBar(title: TabBar(tabs: tabs)),
              drawer: SoulmateDrawer(),
              body: TabBarView(
                children: views,
              ),
            ));
      },
    );
  }
}
