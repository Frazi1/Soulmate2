import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/view/images_list_item.dart';

import 'bottom_loader.dart';

class CustomImagesList<TBloc extends ImagesBloc> extends StatefulWidget {
  final IndexedWidgetBuilder builder;
  final List Function(ImagesState state) getItems;
  final String? Function(ImagesState state) getErrorMessage;
  final void Function(TBloc bloc) fetchImages;

  CustomImagesList(
      {required this.builder, required this.getItems, required this.getErrorMessage, required this.fetchImages});

  @override
  _CustomImagesListState createState() {
    return _CustomImagesListState<TBloc>(builder, getItems, getErrorMessage, fetchImages);
  }
}

class _CustomImagesListState<TBloc extends ImagesBloc> extends State<CustomImagesList> {
  final IndexedWidgetBuilder builder;
  final List Function(ImagesState state) getItems;
  final String? Function(ImagesState state) getErrorMessage;
  final void Function(TBloc) fetchImages;

  final _scrollController = ScrollController();
  late final TBloc _bloc;

  _CustomImagesListState(this.builder, this.getItems, this.getErrorMessage, this.fetchImages);

  @override
  void initState() {
    _bloc = context.read<TBloc>();
    _scrollController.addListener(() => _onScroll(_bloc));
    super.initState();
  }

  void _onScroll(TBloc bloc) {
    if (_isBottom) fetchImages(bloc);
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<TBloc, ImagesState>(
        builder: (context, state) {
          var items = getItems(state);
          if (items.length == 0) {
            return Center(child: Text("No items"));
          }

          return ListView.builder(
            itemBuilder: builder,
            itemCount: items.length,
            controller: _scrollController,
          );
        },
        listener: (context, state) {
          if(state.status == ImagesStatus.failure) {
            var error = getErrorMessage(state);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Could not load: $error")));
          }
        },
      ),
    );
  }
}

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
    return BlocConsumer<ImagesBloc, ImagesState>(
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
            itemBuilder: (context, index) =>
                index >= state.images.length ? BottomLoader() : ImageListItem(index: index),
            itemCount: state.hasReachedMax ? state.images.length : state.images.length + 1,
            controller: _scrollController,
          );
        },
        listenWhen: (previous, current) =>
            previous.status == ImagesStatus.loading && current.status == ImagesStatus.failure,
        listener: (context, state) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text("Could not load images")));
        });
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
