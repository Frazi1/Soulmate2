import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'firebase_auth_event.dart';

part 'firebase_auth_state.dart';

class FirebaseAuthBloc extends Bloc<FirebaseAuthEvent, FirebaseAuthState> {
  FirebaseAuthBloc() : super(FirebaseAuthInitial()) {
    FirebaseAuth.instance.useEmulator('https://10.0.2.2:9099');
  }

  @override
  Stream<FirebaseAuthState> mapEventToState(FirebaseAuthEvent event) async* {
    if (event is UserLoggedInFirebaseAuthEvent) {
      yield FirebaseAuthCompleted(event.user);
    }
  }
}
