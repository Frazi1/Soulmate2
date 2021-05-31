import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'bloc/vk_auth_bloc.dart';

class VkAuthPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => VkAuthPage());

  @override
  Widget build(BuildContext context) {
    var url =
        // "https://oauth.vk.com/authorize?client_id=7865502&scope=groups&redirect_uri=https://oauth.vk.com/blank.html&display=mobile&v=5.131&response_type=token";
        "https://oauth.vk.com/authorize?client_id=7865502&scope=262148&redirect_uri=https://oauth.vk.com/blank.html&display=mobile&v=5.131&response_type=token";
    return BlocConsumer<VkAuthBloc, VkAuthState>(
        listener: (context, state) {
          if (state is VkAuthSucceededState) {
            Navigator.of(context).pop(state);
          }
        },
        builder: (context, state) {
          return WebView(
            initialUrl: url,
            onPageStarted: (url) => context.read<VkAuthBloc>().add(VkAuthRedirectEvent(url)),
          );
        },
      );
  }
}
