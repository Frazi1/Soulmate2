import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:soulmate2/images/likes/favorites_repository.dart';
import 'package:soulmate2/images/models/image.dart';

part 'likes_event.dart';

part 'likes_state.dart';

class LikesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _repository;

  late final StreamSubscription _favoritesSub;

  LikesBloc(this._repository) : super(FavoritesLoadingState()) {
    _favoritesSub = _repository.favorites.listen((favoritesSet) {
      add(FavoritesUpdatedEvent(favorites: favoritesSet));
    });
  }

  @override
  void onEvent(FavoritesEvent event) {
    print('Likes_bloc: got event: ${event}');
  }


  @override
  void onError(Object error, StackTrace stackTrace) {
    print('Likes bloc: error $error');
  }


  @override
  void onChange(Change<FavoritesState> change) {
    print('Likes bloc: changed to state ${change.nextState}');
  }

  @override
  Stream<FavoritesState> mapEventToState(FavoritesEvent event) async* {
    print('Processing event: $event');
    if (event is LoadFavoritesEvent) {
      await _repository.loadFavorites();
    } else if (event is ToggleFavoriteEvent) {
      if (event.liked) {
        try {
          await _repository.addFavorite(event.image);
        } catch (e) {
          print(e);
        }
      } else {
        yield FavoriteDeletingState(event.image);
        await _repository.removeFavorite(event.image);
      }
    } else if (event is FavoritesUpdatedEvent) {
      if (state is FavoritesLoadedState) {
        yield (state as FavoritesLoadedState).copyWith(favorites: event.favorites);
      } else {
        yield FavoritesLoadedState(favorites: event.favorites);
      }
    }
  }

  @override
  Future<void> close() async {
    await _favoritesSub.cancel();
    return super.close();
  }
}
