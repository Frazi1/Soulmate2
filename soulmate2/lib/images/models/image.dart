import 'package:equatable/equatable.dart';

// "albumId": 1,
// "id": 1,
// "title": "accusamus beatae ad facilis cum similique qui sunt",
// "url": "https://via.placeholder.com/600/92c952",
// "thumbnailUrl": "https://via.placeholder.com/150/92c952"
class ImageModel extends Equatable {
  final String url;
  final String sourceType;
  final String id;

  ImageModel({required this.id, required this.sourceType, required this.url});

  @override
  List<Object> get props => [url, sourceType, id];
}
