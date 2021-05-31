import 'dart:async';

import 'package:soulmate2/images/likes/bloc/favorites_bloc.dart';
import 'package:soulmate2/images/models/image.dart';

class ImageRequestResult{
  final List<ImageModel> list;
  final int startIndexNext;

  const ImageRequestResult({required this.list, required this.startIndexNext});
}
abstract class ImagesRepository {
  Future<ImageRequestResult> fetchImages([int startIndex = 0, int limit = 100]);
  Future<void> close();
}