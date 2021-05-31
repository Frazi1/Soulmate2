import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;
import 'package:soulmate2/vk/auth/bloc/vk_auth_bloc.dart';
import 'package:soulmate2/vk/groups/models/VkGroupModel.dart';

part 'vk_groups_event.dart';

part 'vk_groups_state.dart';

class VkGroupsBloc extends HydratedBloc<VkGroupsEvent, VkGroupsState> {
  final VkAuthSucceededState _authState;

  VkGroupsBloc(this._authState) : super(VkGroupsInitial());

  @override
  Stream<VkGroupsState> mapEventToState(VkGroupsEvent event) async* {
    try {
      if (event is VkFetchGroupsEvent) {
        yield await _mapFetchGroupEventToState();
      }
    } catch (e) {
      List<VkGroupModel> existingGroups;
      if (state is VkGroupsFetchedState) {
        existingGroups = (state as VkGroupsFetchedState).groups;
      } else {
        existingGroups = [];
      }
      yield VkGroupsFetchErrorState(e.toString(), existingGroups);
    }
  }

  Future<VkGroupsState> _mapFetchGroupEventToState() async {
    var url = "https://api.vk.com/method/groups.get?access_token=${_authState.accessToken}&user_id=${_authState.userId}&v=5.131&count=1000&extended=1";

    var response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw new Exception("Non-success response: ${response.statusCode}");
    }

    var jsonBody = json.decode(response.body) as Map<String, dynamic>;
    if (jsonBody.containsKey('error')) {
      throw new Exception("Error: ${jsonBody['error']['error_msg']}");
    }
    Iterable<VkGroupModel> groups = (jsonBody['response']['items'] as List).map((e) => VkGroupModel.fromJson(e));
    return VkGroupsFetchedState(groups.toList());
  }

  @override
  VkGroupsState? fromJson(Map<String, dynamic> json) {
    var groups = (json['groups'] as List).map((g) => VkGroupModel.fromJson(g)).toList();
    return VkGroupsFetchedState(groups);
  }

  @override
  Map<String, dynamic>? toJson(VkGroupsState state) {
    if(state is VkGroupsFetchedState){
      return {'groups':state.groups.map((g) => g.toJson()).toList()};
    }
    return null;
  }
}
