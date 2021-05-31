import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:soulmate2/auth/firebase/firebase_auth_bloc.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends HydratedCubit<OnBoardingState> {
  final FirebaseAuthBloc _authBloc;

  late final StreamSubscription _authSub;
  OnBoardingCubit(this._authBloc) : super(OnBoardingState()) {
    _authSub = _authBloc.stream.listen((state) {
      if(state is FirebaseAuthInitial){
        reset();
      } else if(state is FirebaseAuthCompleted){
        complete();
      }
    });
  }


  @override
  void onChange(Change<OnBoardingState> change) {
    print('OnboardingCubit: change to ${change.nextState}');
    super.onChange(change);
  }


  @override
  Future<void> close() async {
    await _authSub.cancel();
    return await super.close();
  }

  void complete() {
    emit(OnBoardingState(isCompleted: true));
  }

  void reset(){
    emit(OnBoardingState(isCompleted: false));
  }

  @override
  OnBoardingState? fromJson(Map<String, dynamic> json) {
    return OnBoardingState(isCompleted: json['wasCompleted'] as bool);
  }

  @override
  Map<String, dynamic>? toJson(OnBoardingState state) {
    return {'wasCompleted': state.isCompleted};
  }
}
