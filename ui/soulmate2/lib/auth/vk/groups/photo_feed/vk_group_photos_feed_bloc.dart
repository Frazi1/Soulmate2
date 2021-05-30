
import 'package:meta/meta.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';

part 'vk_group_photos_feed_event.dart';

part 'vk_group_photos_feed_state.dart';


class VkGroupPhotosFeedBloc extends ImagesBloc {
  final String groupName;
  VkGroupPhotosFeedBloc(this.groupName, ImagesRepository repository) : super(repository);
}
