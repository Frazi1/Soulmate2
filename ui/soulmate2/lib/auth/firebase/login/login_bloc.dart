import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';
import 'package:soulmate2/auth/firebase/models/models.dart';
import 'package:soulmate2/auth/firebase/models/username.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final FirebaseAuthBloc _firebaseAuthBloc;
  LoginBloc(this._firebaseAuthBloc) : super(const LoginState());


  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    }
  }

  LoginState _mapUsernameChangedToState(LoginUsernameChanged event, LoginState state) {
    final username = Username.dirty(event.username);
    return state.copyWith(
      username: username,
      status: Formz.validate([state.password, username]),
    );
  }

  LoginState _mapPasswordChangedToState(LoginPasswordChanged event, LoginState state) {
    final password = Password.dirty(event.password);
    return state.copyWith(
      password: password,
      status: Formz.validate([password, state.username]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(LoginSubmitted event, LoginState state) async* {
    if (state.status.isValidated) {
      yield state.copyWith(status: FormzStatus.submissionInProgress);
      try {
        final result = await FirebaseAuth.instance.signInWithEmailAndPassword(email: state.username.value, password: state.password.value);
        _firebaseAuthBloc.add(UserLoggedInFirebaseAuthEvent(result.user!, firstLogIn: true));
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure, error: e.toString());
      }
    }
  }
}
