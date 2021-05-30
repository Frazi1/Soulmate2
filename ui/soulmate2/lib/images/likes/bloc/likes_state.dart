part of 'likes_bloc.dart';

abstract class FavoritesState extends Equatable {
  @override
  List<Object> get props => [];
}

class FavoritesLoadingState extends FavoritesState {}

class FavoritesLoadedState extends FavoritesState {
  final FavoritesCache favorites;
  final int version;

  FavoritesLoadedState({
    required this.favorites,
    this.version = 1
  });

  @override
  List<Object> get props => [favorites, version];

  FavoritesLoadedState copyWith({required FavoritesCache favorites}){
    return FavoritesLoadedState(favorites: favorites, version: this.version + 1);
  }
}
