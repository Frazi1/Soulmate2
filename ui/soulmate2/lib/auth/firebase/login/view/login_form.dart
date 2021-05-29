import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../../soulmate_logo.dart';
import '../../auth_page.dart';
import '../login_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Authentication Failure:${state.error}')));
          } else if (state.status.isSubmissionSuccess) {
            Navigator.of(context).pushAndRemoveUntil(AuthPage.route(), (route) => false);
          }
        }),
      ],
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SoulmateLogo(),
            const Padding(padding: EdgeInsets.all(12)),
            UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            LoginButton(),
          ],
        ),
      ),
    );
  }
}

class UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) => context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'E-mail',
            errorText: state.username.invalid ? 'invalid username' : null,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          onChanged: (password) => context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.invalid ? 'invalid password' : null,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return state.status.isSubmissionInProgress
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  child: const Text('Login'),
                  onPressed: state.status.isValidated
                      ? () {
                          context.read<LoginBloc>().add(LoginSubmitted(state.username.value, state.password.value));
                        }
                      : null,
                );
        });
  }
}
