import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'vk_auth_event.dart';

part 'vk_auth_state.dart';

class VkAuthBloc extends HydratedBloc<VkAuthEvent, VkAuthState> {
  VkAuthBloc() : super(VkAuthInProgressState());

  @override
  Stream<VkAuthState> mapEventToState(VkAuthEvent event) async* {
    if (event is VkAuthRedirectEvent) {
      yield _mapAuthRedirectEventToState(event);
    } else if (event is VkAuthLogoutEvent) {
      yield _mapAuthLogoutEventToState(event);
    }
  }

  VkAuthState _mapAuthRedirectEventToState(VkAuthRedirectEvent event) {
    var url = Uri.parse(event.redirectUrl.replaceFirst('#', '?'));
    var authenticated = url.queryParameters.containsKey("access_token");

    if (authenticated) {
      var token = url.queryParameters['access_token'] as String;
      var userId = url.queryParameters['user_id'] as String;
      return VkAuthSucceededState(token, userId);
    } else {
      return VkAuthInProgressState();
    }
    //TODO: check for error
  }

  VkAuthState _mapAuthLogoutEventToState(VkAuthLogoutEvent event) {
    return VkAuthInProgressState();
  }

  @override
  VkAuthState? fromJson(Map<String, dynamic> json) {
    if (json.containsKey('accessToken')) {
      return VkAuthSucceededState(json['accessToken'] as String, json['userId'] as String);
    }

    return VkAuthInProgressState();
  }

  @override
  Map<String, dynamic>? toJson(VkAuthState state) {
    if (state is VkAuthSucceededState) {
      return {'accessToken': state.accessToken, 'userId': state.userId};
    }
    return null;
  }
}
