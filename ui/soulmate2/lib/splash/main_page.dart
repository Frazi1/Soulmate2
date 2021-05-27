import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soulmate2/images/likes/view/favorites_page.dart';
import 'package:soulmate2/images/view/images_page.dart';

class MainPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => MainPage());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2,
        child: Scaffold(
          appBar: TabBar(tabs: [
            Tab(icon: Icon(Icons.photo)),
            Tab(icon: Icon(Icons.favorite))
          ]),
          body: TabBarView(children: [
            ImagesPage(),
            FavoritesPage()
          ],),

        ));
  }
}
