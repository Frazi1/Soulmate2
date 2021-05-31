part of 'firebase_auth_bloc.dart';

abstract class FirebaseAuthEvent extends Equatable {
  const FirebaseAuthEvent();

  @override
  List<Object> get props =>[];
}

class UserLoggedInFirebaseAuthEvent extends FirebaseAuthEvent{
  final User user;
  final bool firstLogIn;

  UserLoggedInFirebaseAuthEvent(this.user, {required this.firstLogIn});
}

class UserLoggedOutFirebaseEvent extends FirebaseAuthEvent {

}

