import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:soulmate2/auth/firebase/signup/sign_up_bloc.dart';

import '../../soulmate_logo.dart';

class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0, -1 / 3),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SoulmateLogo(),
          const Padding(padding: EdgeInsets.all(12)),
          _UsernameInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _PasswordInput(),
          const Padding(padding: EdgeInsets.all(12)),
          _SignUpButton(),
        ],
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextField(
          key: const Key('signUp_usernameInput_textField'),
          onChanged: (username) => context.read<SignUpBloc>().add(SignUpUsernameChanged(username)),
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
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('signUp_passwordInput_textField'),
          onChanged: (password) => context.read<SignUpBloc>().add(SignUpPasswordChanged(password)),
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

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpBloc, SignUpState>(listener: (context, state) {
      if (state.error != null) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.error!),
              backgroundColor: Colors.red,
            ),
          );
      }
    }, builder: (context, state) {
      return state.status.isSubmissionInProgress
          ? const CircularProgressIndicator()
          : ElevatedButton(
              key: const Key('signUpForm_continue_raisedButton'),
              child: const Text('Sign Up'),
              onPressed: state.status.isValid || state.status.isValidated
                  ? () {
                      context.read<SignUpBloc>().add(SignUpSubmitted(state.username.value, state.password.value));
                    }
                  : null,
            );
    });
  }
}
