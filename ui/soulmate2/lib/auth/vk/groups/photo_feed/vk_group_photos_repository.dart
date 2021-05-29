import 'package:soulmate2/auth/vk/auth/bloc/vk_auth_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/models/image.dart';

import '../../api_helper.dart';

class VkGroupImagesRepository extends ImagesRepository {
  final VkAuthSucceededState authState;
  final String groupId;

  VkGroupImagesRepository(this.authState, this.groupId);

  @override
  Future<void> close() => Future.value(null);

  @override
  Future<List<ImageModel>> fetchImages([int startIndex = 0, int limit = 5]) async {
    var ownerId = '-$groupId';
    var response = await VkApiHelper.invokeApi(
        'wall.get?access_token=${authState.accessToken}&owner_id=$ownerId&offset=$startIndex&limit=$limit&v=5.131');
    var postAttachments = (response['response']['items'] as List)
        .where((item) => (item as Map<String, dynamic>).containsKey('attachments'))
        .map((e) => e['attachments'] as List)
        .toList();

    var flatten = [];
    postAttachments.forEach((element) {flatten.addAll(element); });
    var photoAtthachments = flatten
        .where((element) => element['type'] == 'photo')
        .map((e) => e['photo']).toList();

    var allSizes = photoAtthachments
        .map((photo) => photo['sizes'] as List)
        .toList();
    var lastLizes = allSizes.map((sizes) => sizes.last).toList();

    var biggestPhotos = lastLizes
        .map((size) => ImageModel(size['url'] as String))
        .toList();

    return biggestPhotos.toList();
  }
}
