part of 'firebase_auth_bloc.dart';

abstract class FirebaseAuthState extends Equatable {
  const FirebaseAuthState();

  @override
  List<Object> get props => [];
}

class FirebaseAuthInitial extends FirebaseAuthState {
}

class FirebaseAuthCompleted extends FirebaseAuthState{
  final User user;
  FirebaseAuthCompleted(this.user);

  @override
  List<Object> get props => [user];
}
