import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soulmate2/images/likes/view/favorites_page.dart';
import 'package:soulmate2/soulmate_drawer.dart';
import 'auth/firebase/firebase_auth_bloc.dart';
import 'auth/vk/auth/bloc/vk_auth_bloc.dart';
import 'favorites/favorites_page.dart';
import 'images/likes/bloc/likes_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  await Firebase.initializeApp();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(create: (_) => LikesBloc()),
    BlocProvider(create: (_) => VkAuthBloc()),
    BlocProvider(create: (_) => FirebaseAuthBloc())
  ], child: App()));
}

class App extends StatelessWidget {
  final _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      navigatorKey: GlobalKey<NavigatorState>(),
      home: FutureBuilder(
          future: _fbApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error loading Firebase:${snapshot.error}');
            } else if (snapshot.hasData) {
              return FavoritesPage();
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
