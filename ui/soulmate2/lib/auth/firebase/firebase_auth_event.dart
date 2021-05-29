part of 'firebase_auth_bloc.dart';

abstract class FirebaseAuthEvent extends Equatable {
  const FirebaseAuthEvent();

  @override
  List<Object> get props =>[];
}

class UserLoggedInFirebaseAuthEvent extends FirebaseAuthEvent{
  final User user;

  UserLoggedInFirebaseAuthEvent(this.user);
}

class UserLoggedOutFirebaseEvent extends FirebaseAuthEvent {

}

