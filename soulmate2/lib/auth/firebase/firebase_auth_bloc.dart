import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:soulmate2/favorites/favorites_repository.dart';

part 'firebase_auth_event.dart';

part 'firebase_auth_state.dart';

class FirebaseAuthBloc extends Bloc<FirebaseAuthEvent, FirebaseAuthState> {
  final FavoritesRepository _favoritesRepository;

  FirebaseAuthBloc(this._favoritesRepository) : super(FirebaseAuthInitial()) {
    if (FirebaseAuth.instance.currentUser != null) {
      add(UserLoggedInFirebaseAuthEvent(FirebaseAuth.instance.currentUser!, firstLogIn: false));
    }
  }

  @override
  Stream<FirebaseAuthState> mapEventToState(FirebaseAuthEvent event) async* {
    if (event is UserLoggedInFirebaseAuthEvent) {
      try {
        if (event.firstLogIn) {
          await FirebaseDatabase.instance.setPersistenceEnabled(true);
          await _favoritesRepository.transferDataToUser(event.user.uid);
        }
      } catch (e) {
        print('Error when transferring data to user: $e');
      }

      _favoritesRepository.setFavorites();
      await Firebase.initializeApp();
      await FirebaseDatabase.instance.goOnline();
      yield FirebaseAuthCompleted(event.user);
    } else if (event is UserLoggedOutFirebaseEvent) {
      FirebaseDatabase.instance.goOffline();
      await FirebaseAuth.instance.signOut();
      FirebaseDatabase.instance.setPersistenceEnabled(true);
      yield FirebaseAuthInitial();
      _favoritesRepository.setFavorites();
    }
  }
}
