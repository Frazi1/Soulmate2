part of 'images_bloc.dart';


abstract class ImagesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchImages extends ImagesEvent {}

class ToggleImageLike extends ImagesEvent {
  final int imageIndex;

  ToggleImageLike(this.imageIndex);

  @override
  List<Object> get props => [imageIndex];
}