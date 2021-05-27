part of 'likes_bloc.dart';

class LikesState extends Equatable {
  final ImageModel image;

  LikesState(this.image);

  @override
  List<Object> get props => [image];
}
