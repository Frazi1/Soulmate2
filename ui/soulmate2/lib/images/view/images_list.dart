import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/view/images_list_item.dart';

import 'bottom_loader.dart';

class ImagesList extends StatefulWidget {
  @override
  _ImagesListState createState() => _ImagesListState();
}

class _ImagesListState extends State<ImagesList> {
  final _scrollController = ScrollController();
  late ImagesBloc _imagesBloc;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _imagesBloc = context.read<ImagesBloc>();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ImagesBloc, ImagesState>(
      buildWhen: (previous, current) =>
          current.images.length > previous.images.length || current.status != previous.status,
      builder: (context, state) {
        if (state.status == ImagesStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.images.isEmpty) {
          return const Center(child: Text('no images'));
        }
        return ListView.builder(
          itemBuilder: (context, index) => index >= state.images.length ? BottomLoader() : ImageListItem(index: index),
          itemCount: state.hasReachedMax ? state.images.length : state.images.length + 1,
          controller: _scrollController,
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) _imagesBloc.add(FetchImages());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
