import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soulmate2/images/bloc/images_bloc.dart';
import 'package:soulmate2/images/images_repository.dart';
import 'package:soulmate2/images/likes/bloc/likes_bloc.dart';

import 'images_list.dart';

class ImagesPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => ImagesPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => LikesBloc()),
          BlocProvider(create: (_) => ImagesBloc(ImagesRepository())..add(FetchImages()))
        ],
        child: BlocListener<ImagesBloc, ImagesState>(
          listenWhen: (previous, current) =>
              previous.status == ImagesStatus.loading && current.status == ImagesStatus.failure,
          listener: (context, state) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text("Could not load images")));
          },
          child: ImagesList(),
        ),
      ),
    );
  }
}
