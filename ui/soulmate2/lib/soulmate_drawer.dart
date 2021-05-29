import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soulmate2/images/likes/view/favorites_page.dart';
import 'package:soulmate2/images/view/images_page.dart';

import 'login/vk/vk_page.dart';

class SoulmateDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(child: Text("Soulmate")),
          ListTile(
            title: Row(
              children: [
                Icon(Icons.favorite),
                const Text('Favorites'),
              ],
            ),
          ),
          ListTile(
            title: const Text('VK'),
            onTap: () => Navigator.of(context).push(VkPage.route()),
          )
        ],
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => MainPage());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: TabBar(tabs: [Tab(icon: Icon(Icons.photo)), Tab(icon: Icon(Icons.favorite))]),
          ),
          drawer: SoulmateDrawer(),
          body: TabBarView(
            children: [ImagesPage(), FavoritesPage()],
          ),
        ));
  }
}
