part of 'images_bloc.dart';

enum ImagesStatus { initial,
  loading,
  success,
failure }

class ImagesState extends Equatable {
  const ImagesState({
    this.status = ImagesStatus.initial,
    this.images = const <ImageModel>[],
    this.hasReachedMax = false,
    this.version = 1
  });

  final int version;
  final ImagesStatus status;
  final List<ImageModel> images;
  final bool hasReachedMax;

  ImagesState nextVersionWith({
    ImagesStatus? status,
    List<ImageModel>? images,
    List<int>? updatedImages,
    bool? hasReachedMax,
  }) {
    return ImagesState(
      status: status ?? this.status,
      images: images ?? this.images,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      version: version + 1
    );
  }

  @override
  String toString() {
    return '''ImagesState { status: $status, hasReachedMax: $hasReachedMax, images: ${images.length} }''';
  }

  @override
  List<Object> get props => [version, status, hasReachedMax];
}
