import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth/vk/vk_page.dart';
import 'favorites/favorites_page.dart';

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
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(FavoritesPage.route());
            },
          ),
          ListTile(
            title: const Text('VK'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(VkPage.route());
            },
          )
        ],
      ),
    );
  }
}
