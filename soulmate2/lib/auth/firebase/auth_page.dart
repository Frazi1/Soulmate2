import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';
import 'package:soulmate2/auth/firebase/signup/sign_up_page.dart';
import 'login/view/login_page.dart';

class AuthPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => AuthPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BlocBuilder<FirebaseAuthBloc, FirebaseAuthState>(
            builder: (context, state) {
              if (state is FirebaseAuthInitial) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'You are not logged in.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const Text('Please sign in to enable synchronization with your cloud account'),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text('Sign In'),
                        onPressed: () => Navigator.of(context).push(LoginPage.route()),
                      ),
                    ),
                    const Text("Don't have an account?"),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: const Text('Sign Up'),
                        onPressed: () => Navigator.of(context).push(SignUpPage.route()),
                      ),
                    ),
                  ],
                );
              }

              final user = (state as FirebaseAuthCompleted).user;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Logged in as ${user.email}'),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text('Logout'),
                      onPressed: () => context.read<FirebaseAuthBloc>().add(UserLoggedOutFirebaseEvent()),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
