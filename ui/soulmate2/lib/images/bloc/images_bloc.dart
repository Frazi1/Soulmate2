import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/models/image.dart';
import 'package:rxdart/rxdart.dart';

part 'images_event.dart';

part 'images_state.dart';

class ImagesBloc extends Bloc<ImagesEvent, ImagesState> {
  final ImagesRepository _imagesRepository;
  final bool reverseList;

  ImagesBloc(this._imagesRepository, {this.reverseList = false}) : super(const ImagesState());

  @override
  void onChange(Change<ImagesState> change) {
    print('Images bloc: changing to ${change.nextState}');
    super.onChange(change);
  }

  @override
  Stream<Transition<ImagesEvent, ImagesState>> transformEvents(
      Stream<ImagesEvent> events, TransitionFunction<ImagesEvent, ImagesState> transitionFn) {
    return super.transformEvents(events.throttleTime(const Duration(milliseconds: 1500)), transitionFn);
  }

  @override
  Stream<ImagesState> mapEventToState(ImagesEvent event) async* {
    if (event is FetchImages) {
      print('Loading more images');
      yield state.nextVersionWith(status: ImagesStatus.loading);
      yield await _mapPostFetchedToState(state);
    }
  }

  Future<ImagesState> _mapPostFetchedToState(ImagesState state) async {
    // if (state.hasReachedMax) return state;
    try {
      if (state.status == ImagesStatus.initial) {
        final images = await _imagesRepository.fetchImages();
        return state.nextVersionWith(
          status: ImagesStatus.success,
          images: images,
          hasReachedMax: false,
        );
      }
      final images = await _imagesRepository.fetchImages(state.images.length);
      if (images.isEmpty) {
        return state.nextVersionWith(status: ImagesStatus.success, hasReachedMax: true);
      }
      var list;
      if (reverseList) {
        list = List.of(images.reversed)..addAll(state.images);
      } else {
       list = List.of(state.images)..addAll(images);
      }
      return state.nextVersionWith(
        status: ImagesStatus.success,
        images: list,
        hasReachedMax: false,
      );
    } catch (e) {
      print(e);
      return state.nextVersionWith(status: ImagesStatus.failure);
    }
  }

  // @override
  // ImagesState? fromJson(Map<String, dynamic> json) {
  //   if(!_persistCache) return null;
  //   if (json == null) return null;
  //
  //   var result = ImagesState(
  //       status: ImagesStatus.success,
  //       version: json['version'] as int,
  //       images: (json['images'] as List)
  //           .map((jsonImg) => ImageModel(jsonImg['url'] as String))
  //           .toList());
  //   return result;
  // }

  // @override
  // Map<String, dynamic>? toJson(ImagesState state) {
  //   if(!_persistCache) return null;
  //   if (state.status != ImagesStatus.success) return null;
  //   var result = {
  //     'version': state.version,
  //     'images': state.images.map((img) => {'url': img.url}).toList(),
  //   };
  //   return result;
  // }

  @override
  Future<void> close() async {
    await _imagesRepository.close();
    return super.close();
  }
}
