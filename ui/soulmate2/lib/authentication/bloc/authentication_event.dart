part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class AuthenticationStatusChanged extends AuthenticationEvent {
  const AuthenticationStatusChanged(this.authenticationResult);

  final AuthenticationResult authenticationResult;
  @override
  List<Object> get props => [authenticationResult];
}

class AuthenticationLogoutRequested extends AuthenticationEvent {}
