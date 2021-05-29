import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/view/images_list_item.dart';

import 'images_list.dart';

class ImagesPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => ImagesPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [BlocProvider(create: (_) => ImagesBloc(TestingImagesRepository(), true)..add(FetchImages()))],
        // child: ImagesList(),
        child: CustomImagesList<ImagesBloc>(
          builder: (context, index) => ImageListItem(index: index),
          getItems: (state) => state.images,
          fetchImages:(bloc) => bloc.add(FetchImages()),
          getErrorMessage: (state) => null
        ),
      ),
    );
  }
}
