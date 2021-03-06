import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/models/image.dart';
import 'package:soulmate2/vk/auth/bloc/vk_auth_bloc.dart';

import '../../api_helper.dart';

class VkGroupImagesRepository extends ImagesRepository {
  final VkAuthSucceededState authState;
  final String groupId;

  VkGroupImagesRepository(this.authState, this.groupId);

  @override
  Future<void> close() => Future.value(null);

  @override
  Future<ImageRequestResult> fetchImages([int startIndex = 0, int limit = 100]) async {
    var ownerId = '-$groupId';
    var response = await VkApiHelper.invokeApi(
        'wall.get?access_token=${authState.accessToken}&owner_id=$ownerId&offset=$startIndex&limit=$limit&v=5.131');
    var postAttachments = (response['response']['items'] as List)
        .where((item) => (item as Map<String, dynamic>).containsKey('attachments'))
        .map((e) => e['attachments'] as List)
        .toList();

    var flatten = [];
    postAttachments.forEach((element) {
      flatten.addAll(element);
    });
    var photoAtthachments = flatten
        .where((element) => element['type'] == 'photo')
        .map((e) => e['photo']).toList();

    var list = photoAtthachments.map((e) =>
        ImageModel(
            id: (e['id'] as int).toString(),
            sourceType: 'vk',
            url: ((e['sizes'] as List).last as Map)['url'] as String))
        .toList();
    return ImageRequestResult(list: list, startIndexNext: startIndex + limit);
  }
}
