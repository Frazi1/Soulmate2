import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';
import 'package:soulmate2/auth/firebase/signup/sign_up_bloc.dart';
import 'package:soulmate2/auth/firebase/signup/sign_up_view.dart';

class SignUpPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => SignUpPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) => SignUpBloc(context.read<FirebaseAuthBloc>()),
          child: BlocListener<SignUpBloc, SignUpState>(
            listener: (context, state) {
              if (state is UserLoggedInFirebaseAuthEvent) {
                Navigator.of(context).pop();
              }
            },
            child: SignUpView(),
          ),
        ),
      ),
    );
  }
}
