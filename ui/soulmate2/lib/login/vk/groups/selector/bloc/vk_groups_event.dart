part of 'vk_groups_bloc.dart';

abstract class VkGroupsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class VkFetchGroupsEvent extends VkGroupsEvent {}
