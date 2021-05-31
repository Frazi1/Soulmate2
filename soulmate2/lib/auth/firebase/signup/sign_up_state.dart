part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  final FormzStatus status;
  final Username username;
  final Password password;
  final String? error;

  const SignUpState({
    this.status = FormzStatus.pure,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.error
  });

  SignUpState copyWith({
    FormzStatus? status,
    Username? username,
    Password? password,
    String? error,
  }) {
    return SignUpState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      error: error
    );
  }

  @override
  List<Object> get props => [status, username, password, error ?? ""];
}
