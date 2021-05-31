import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'on_boarding_state.dart';

class OnBoardingCubit extends HydratedCubit<OnBoardingState> {
  OnBoardingCubit() : super(OnBoardingState());

  void complete() => emit(OnBoardingState(isCompleted: true));

  @override
  OnBoardingState? fromJson(Map<String, dynamic> json) {
    return OnBoardingState(isCompleted: json['isCompleted'] as bool);
  }

  @override
  Map<String, dynamic>? toJson(OnBoardingState state) {
    return {'isCompleted': state.isCompleted};
  }
}
