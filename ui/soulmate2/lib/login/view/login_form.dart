import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:soulmate2/authentication/authentication.dart';
import 'package:soulmate2/login/bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoginBloc, LoginState>(listener: (context, state) {
          if (state.status.isSubmissionFailure || state.errorText != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text('Authentication Failure:${state.errorText}')));
          }
        }),
      ],
      child: Align(
        alignment: const Alignment(0, -1 / 3),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Logo(),
            const Padding(padding: EdgeInsets.all(12)),
            _UsernameInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _PasswordInput(),
            const Padding(padding: EdgeInsets.all(12)),
            _LoginButton(),
          ],
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Soulmate',
      style: TextStyle(
        color: Theme
            .of(context)
            .primaryColor,
        fontSize: 40,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (username) => context.read<LoginBloc>().add(LoginUsernameChanged(username)),
          decoration: InputDecoration(
            labelText: 'Username',
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

class _LoginButton extends StatelessWidget {
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
