import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/view/images_page.dart';
import 'package:user_repository/user_repository.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'splash/view/splash_page.dart';
import 'home/view/home_page.dart';
import 'login/view/login_page.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.userRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,
        ),
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            _navigator.pushAndRemoveUntil(ImagesPage.route(), (route) => false);
            return;
            switch (state.status) {
              case AuthenticationStatus.authenticated:
                // _navigator.pushAndRemoveUntil<void>(HomePage.route(), (route) => false);
                break;
              case AuthenticationStatus.unauthenticated:
                _navigator.pushAndRemoveUntil<void>(LoginPage.route(), (route) => false);
                break;
              default:
                break;
            }
          },
          child: child,
        );
      },
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
