part of 'likes_bloc.dart';

abstract class LikesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ToggleLikeEvent extends LikesEvent {
  final String imageUrl;
  final bool liked;

  ToggleLikeEvent(this.imageUrl, this.liked);

  @override
  List<Object> get props => [liked];
}
