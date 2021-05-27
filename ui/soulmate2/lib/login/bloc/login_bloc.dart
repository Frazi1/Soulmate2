import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:soulmate2/login/models/models.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  })  : _authenticationRepository = authenticationRepository,
        super(const LoginState()) {
    _statusSubs = authenticationRepository.status.listen((event) {
      if (event.status == AuthenticationStatus.unauthenticated && event.description != null) {
        add(LoginFailed(event.description.toString()));
      }
    });
  }

  final AuthenticationRepository _authenticationRepository;
  late StreamSubscription<AuthenticationResult> _statusSubs;

  @override
  Future<void> close() {
    _statusSubs.cancel();
    return super.close();
  }

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginUsernameChanged) {
      yield _mapUsernameChangedToState(event, state);
    } else if (event is LoginPasswordChanged) {
      yield _mapPasswordChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    } else if (event is LoginFailed) {
      yield _mapLoginFailedToState(event, state);
    }
  }

  LoginState _mapLoginFailedToState(LoginFailed event, LoginState state){
    return state.copyWith(errorText: event.reason.toString());
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
        await _authenticationRepository.logIn(
          state.username.value,
          state.password.value,
        );
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      } on Exception catch (_) {
        yield state.copyWith(status: FormzStatus.submissionFailure);
      }
    }
  }
}
