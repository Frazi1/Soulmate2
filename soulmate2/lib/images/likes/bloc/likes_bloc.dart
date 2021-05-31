import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:soulmate2/images/likes/favorites_repository.dart';
import 'package:soulmate2/images/models/image.dart';

part 'likes_event.dart';

part 'likes_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesRepository _repository;

  late final StreamSubscription _favoritesSub;

  FavoritesBloc(this._repository) : super(FavoritesLoadingState()) {
    _favoritesSub = _repository.favorites.listen((update) {
      final isDeleted = update.deleted.isNotEmpty;
      final image = isDeleted?update.deleted.first : update.added.first;
      add(FavoritesUpdatedEvent(image: image, isDeleted: isDeleted, cache: update.cache));
    });
  }

  @override
  void onEvent(FavoritesEvent event) {
    print('Likes_bloc: got event: $event');
    super.onEvent(event);
  }


  @override
  void onError(Object error, StackTrace stackTrace) {
    print('Likes bloc: error $error');
    super.onError(error, stackTrace);
  }


  @override
  void onChange(Change<FavoritesState> change) {
    print('Likes bloc: changed to state ${change.nextState}');
    super.onChange(change);
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
        await _repository.removeFavorite(event.image);
      }
    } else if (event is FavoritesUpdatedEvent) {
      if (state is FavoritesLoadedState) {
        var loadedState = (state as FavoritesLoadedState);
        if(event.isDeleted){
          loadedState.favorites.remove(event.image);
        } else {
          loadedState.favorites.add(event.image);
        }
        yield loadedState.copyWith(favorites: loadedState.favorites);
      } else {
        if(!event.isDeleted) {
          yield FavoritesLoadedState(favorites: [event.image], cache: event.cache);
        }
      }
    }
  }

  @override
  Future<void> close() async {
    await _favoritesSub.cancel();
    return super.close();
  }
}
