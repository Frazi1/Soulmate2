import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:soulmate2/images/likes/favorites_repository.dart';
import 'auth/firebase/firebase_auth_bloc.dart';
import 'favorites/favorites_page.dart';
import 'favorites/upload/favorites_upload_cubit.dart';
import 'images/likes/bloc/likes_bloc.dart';
import 'on_boarding/on_boarding_cubit.dart';
import 'on_boarding/on_boarding_page.dart';
import 'vk/auth/bloc/vk_auth_bloc.dart';

const USE_FIREBASE_EMULATOR = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  await Firebase.initializeApp();
  FirebaseDatabase database;
  if (USE_FIREBASE_EMULATOR) {
    await FirebaseAuth.instance.useEmulator('http://localhost:9099');
    database = FirebaseDatabase(databaseURL: 'http://10.0.2.2:9000');
  } else{
    database = FirebaseDatabase();
  }
  database.setPersistenceEnabled(true);

  if (FirebaseAuth.instance.currentUser == null) {
    await database.goOffline();
  }

  runApp(RepositoryProvider(
    create: (context) => FavoritesRepository(database),
    child: MultiBlocProvider(providers: [
      BlocProvider(create: (_) => OnBoardingCubit()),
      BlocProvider(create: (context) {
        return LikesBloc(RepositoryProvider.of<FavoritesRepository>(context))..add(LoadFavoritesEvent());
      }),
      BlocProvider(create: (_) => VkAuthBloc()),
      BlocProvider(create: (context) => FirebaseAuthBloc(RepositoryProvider.of<FavoritesRepository>(context))),
      BlocProvider(create: (context) => FavoritesUploadCubit(context.read<LikesBloc>()))
    ], child: App()),
  ));
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
              return context.read<OnBoardingCubit>().state.isCompleted ? FavoritesPage() : OnBoardingPage();
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}
