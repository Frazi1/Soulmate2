part of 'likes_bloc.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final List<ImageModel> favorites;
  final FavoritesCache cache;
  final int version;

  FavoritesLoadedState({
    required this.favorites,
    required this.cache,
    this.version = 1
  });

  @override
  List<Object> get props => [favorites, version];

  FavoritesLoadedState copyWith({required List<ImageModel> favorites}){
    return FavoritesLoadedState(favorites: favorites, cache: this.cache, version: this.version + 1);
  }
}