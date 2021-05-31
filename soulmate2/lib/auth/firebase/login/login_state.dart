part of 'login_bloc.dart';

class LoginState extends Equatable {
  final FormzStatus status;
  final Username username;
  final Password password;
  final String? error;

  const LoginState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.error
  });

  LoginState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
    String? error
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      error: error
    );
  }

  @override
  List<Object> get props => [status, username, password];
}
