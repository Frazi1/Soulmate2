part of 'vk_auth_bloc.dart';


abstract class VkAuthEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class VkAuthRedirectEvent extends VkAuthEvent {
  final String redirectUrl;

  VkAuthRedirectEvent(this.redirectUrl);

  @override
  List<Object> get props => [redirectUrl];
}

class VkAuthLogoutEvent extends VkAuthEvent{

}