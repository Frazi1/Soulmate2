part of 'likes_bloc.dart';

class LikesState extends Equatable {
  final Map<String, bool> likedUrls;
  final int version;

  LikesState({this.version = 1, this.likedUrls = const {}});

  @override
  List<Object> get props => [version, likedUrls];

  LikesState getNextVersion({required Map<String,bool> likedUrls}) => LikesState(version: version +1, likedUrls: likedUrls);
}
