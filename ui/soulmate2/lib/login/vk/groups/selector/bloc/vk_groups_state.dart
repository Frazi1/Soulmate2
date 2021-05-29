part of 'vk_groups_bloc.dart';

@immutable
abstract class VkGroupsState {}

class VkGroupsInitial extends VkGroupsState {}

class VkGroupsFetchedState extends VkGroupsState {
  final List<VkGroupModel> groups;

  VkGroupsFetchedState(this.groups);

  @override
  List<Object> get props => [groups];
}

class VkGroupsFetchErrorState extends VkGroupsFetchedState {
  final String error;

  VkGroupsFetchErrorState(this.error, existingGroups) : super(existingGroups);

  @override
  List<Object> get props => super.props..add(error);
}