import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../api_helper.dart';

part 'vk_auth_event.dart';

part 'vk_auth_state.dart';

class VkAuthBloc extends HydratedBloc<VkAuthEvent, VkAuthState> {
  VkAuthBloc() : super(VkAuthInProgressState());

  @override
  Stream<VkAuthState> mapEventToState(VkAuthEvent event) async* {
    if (event is VkAuthRedirectEvent) {
      yield await _mapAuthRedirectEventToState(event);
    } else if (event is VkAuthLogoutEvent) {
      yield _mapAuthLogoutEventToState(event);
    }
  }

  Future<VkAuthState> _mapAuthRedirectEventToState(VkAuthRedirectEvent event) async {
    var url = Uri.parse(event.redirectUrl.replaceFirst('#', '?'));
    var authenticated = url.queryParameters.containsKey("access_token");

    if (authenticated) {
      var token = url.queryParameters['access_token'] as String;
      var userId = url.queryParameters['user_id'] as String;
      String displayName;
      String? avaUrl;
      try {
        final accountInfo = await VkApiHelper.invokeApi('users.get?access_token=$token&v=5.131&fields=photo_50');
        var response = (accountInfo['response'] as List).single;
        displayName = '${response['first_name']} ${response['last_name']}';
        avaUrl = response['photo_50'];
      } catch (e) {
        print('Error loading VK account info:$e');
        displayName = userId;
      }
      return VkAuthSucceededState(accessToken: token, userId: userId, displayName: displayName, avaUrl: avaUrl);
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
    if (json.containsKey('accessToken') && json.containsKey('displayName')) {
      return VkAuthSucceededState(
        accessToken: json['accessToken'] as String,
        userId: json['userId'] as String,
        displayName: json['displayName'],
        avaUrl: json['avaUrl'],
      );
    }

    return VkAuthInProgressState();
  }

  @override
  Map<String, dynamic>? toJson(VkAuthState state) {
    if (state is VkAuthSucceededState) {
      return {
        'accessToken': state.accessToken,
        'userId': state.userId,
        'displayName': state.displayName,
        'avaUrl': state.avaUrl
      };
    }
    return null;
  }
}
