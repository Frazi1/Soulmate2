import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:soulmate2/images/models/image.dart';

part 'likes_event.dart';
part 'likes_state.dart';

class LikesBloc extends Bloc<LikesEvent, LikesState> {
  LikesBloc(ImageModel image) : super(LikesState(image));

  @override
  Stream<LikesState> mapEventToState(LikesEvent event) async* {
    if (event is ToggleLikeEvent) {
      yield LikesState(state.image.copyWith(liked: !state.image.liked));
    }
  }
}
