part of 'favorites_bloc.dart';

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
  final ImageModel image;
  final bool isDeleted;
  final FavoritesCache cache;

  FavoritesUpdatedEvent({required this.image, required this.isDeleted, required this.cache});

  @override
  List<Object> get props => [image, isDeleted];
}
