import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';
import 'package:soulmate2/images/models/image.dart';
import 'package:uuid/uuid.dart';

part 'favorites_upload_state.dart';

class FavoritesUploadCubit extends Cubit<FavoritesUploadState> {
  final LikesBloc _likesBloc;

  late final StreamSubscription _likesSub;

  FavoritesUploadCubit(this._likesBloc) : super(FavoritesUploadInitial()) {
    _likesSub = _likesBloc.stream.listen((state) async {
      if (state is FavoriteDeletingState && state.image.sourceType == 'custom') {
        await deleteImage(state.image);
      }
    });
  }

  Future<void> uploadImage(String filePath) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final imageId = Uuid().v4().toString();

    final newFileRef = FirebaseStorage.instance.ref('favorite-images').child(uid).child(imageId);
    final task = newFileRef
        .putFile(File(filePath))
        .then((e) => print('Image uploaded'))
        .catchError((e) => print('Error uploading file: $e'));
    await task;

    final url = await newFileRef.getDownloadURL();

    final image = ImageModel(id: imageId, sourceType: 'custom', url: url);
    _likesBloc.add(ToggleFavoriteEvent(image, true));
  }

  Future<void> deleteImage(ImageModel image) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseStorage.instance
        .ref('favorite-images')
        .child(uid)
        .child(image.id)
        .delete()
        .then((value) => 'Image file for ${image.sourceType}-${image.id} was deleted')
        .catchError((err) => 'Error deleting image file for ${image.sourceType}-${image.id}: $err');
  }

  @override
  Future<void> close() async {
    await _likesSub.cancel();
    return await super.close();
  }
}
