import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends HydratedCubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingState());


  @override
  void onChange(Change<OnBoardingState> change) {
    print('OnboardingCubit: change to ${change.nextState}');
    super.onChange(change);
  }

  void complete() {
    emit(OnBoardingState(isCompleted: true));
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
