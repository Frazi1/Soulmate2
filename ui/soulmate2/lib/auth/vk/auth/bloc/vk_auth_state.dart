part of 'vk_auth_bloc.dart';

abstract class VkAuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class VkAuthInProgressState extends VkAuthState {}

class VkAuthRejectedState extends VkAuthState {
  final String errorMessage;

  VkAuthRejectedState(this.errorMessage);

  @override
  List<Object> get props => [];
}

class VkAuthSucceededState extends VkAuthState {
  final String accessToken;
  final String userId;

  VkAuthSucceededState(this.accessToken, this.userId);

  @override
  List<Object> get props => [accessToken, userId];
}
