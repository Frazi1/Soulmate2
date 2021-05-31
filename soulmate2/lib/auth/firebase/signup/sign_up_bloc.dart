import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:formz/formz.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';
import 'package:soulmate2/auth/firebase/models/models.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final FirebaseAuthBloc _firebaseAuthBloc;

  SignUpBloc(this._firebaseAuthBloc) : super(SignUpState());

  @override
  Stream<SignUpState> mapEventToState(SignUpEvent event) async* {
    if (event is SignUpUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is SignUpPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is SignUpSubmitted) {
      yield state.copyWith(status:FormzStatus.submissionInProgress);
      try {
        final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: event.username, password: event.password);
        _firebaseAuthBloc.add(UserLoggedInFirebaseAuthEvent(result.user!, firstLogIn: true));
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } catch (e) {
        yield state.copyWith(status: FormzStatus.submissionFailure, error: e.toString());
      }
    }
  }

  SignUpState _mapUsernameChangedToState(SignUpUsernameChanged event, SignUpState state) {
    final username = Username.dirty(event.username);
    var validate = Formz.validate([state.password, username]);
    return state.copyWith(
      username: username,
      status: validate,
    );
  }

  SignUpState _mapPasswordChangedToState(SignUpPasswordChanged event, SignUpState state) {
    final password = Password.dirty(event.password);
    var validate = Formz.validate([password, state.username]);
    return state.copyWith(
      password: password,
      status: validate,
    );
  }
}
