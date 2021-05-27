import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:soulmate2/images/models/image.dart';

part 'likes_event.dart';
part 'likes_state.dart';

class LikesBloc extends HydratedBloc<LikesEvent, LikesState> {
  LikesBloc() : super(LikesState());

  @override
  Stream<LikesState> mapEventToState(LikesEvent event) async* {
    if (event is ToggleLikeEvent) {
      var newLikedUrls = state.likedUrls.map((key, value) => MapEntry(key, value));
      newLikedUrls[event.imageUrl] = event.liked;

      yield state.getNextVersion(likedUrls: newLikedUrls);
    }
  }

  @override
  LikesState? fromJson(Map<String, dynamic> json) {
    var likedUrls = json.map((key, value) => MapEntry(key, value as bool));
    return LikesState(likedUrls: likedUrls);
  }

  @override
  Map<String, dynamic>? toJson(LikesState state) {
   return state.likedUrls;
  }
}
