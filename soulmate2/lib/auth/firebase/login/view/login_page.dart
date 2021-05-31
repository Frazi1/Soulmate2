import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';
import 'package:soulmate2/auth/firebase/login/login_bloc.dart';

import 'login_form.dart';

class LoginPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign In'),),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) => LoginBloc(context.read<FirebaseAuthBloc>()),
          child: LoginForm(),
        ),
      ),
    );
  }
}
