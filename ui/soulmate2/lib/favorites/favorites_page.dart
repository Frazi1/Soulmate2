import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/auth/firebase/auth_page.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';
import 'package:soulmate2/images/likes/view/favorites_list.dart';
import 'package:soulmate2/soulmate_drawer.dart';

class FavoritesPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => FavoritesPage());

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FirebaseAuthBloc, FirebaseAuthState>(
      builder: (context, state) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: TabBar(
                tabs: [
                  Tab(child: Icon(Icons.favorite)),
                  Tab(child: Icon(Icons.account_circle)),
                ],
              ),
            ),
            drawer: SoulmateDrawer(),
            body: TabBarView(
              children: [
                FavoritesList(),
                AuthPage(),
              ],
            ),
          ),
        );
      },
    );
  }
}
