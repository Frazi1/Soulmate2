part of 'likes_bloc.dart';

abstract class FavoritesEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {

}

class ToggleFavoriteEvent extends FavoritesEvent {
  final ImageModel image;
  final bool liked;

  ToggleFavoriteEvent(this.image, this.liked);

  @override
  List<Object> get props => [liked, image];
}

class FavoritesUpdatedEvent extends FavoritesEvent {
  final FavoritesCache favorites;

  FavoritesUpdatedEvent({required this.favorites});

  @override
  List<Object> get props => [favorites];
}
