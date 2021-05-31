import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:soulmate2/auth/soulmate_logo.dart';
import 'package:soulmate2/favorites/favorites_page.dart';
import 'package:soulmate2/splash/on_boarding_cubit.dart';

class OnBoardingPage extends StatelessWidget {
  static Route route() => MaterialPageRoute<void>(builder: (_) => OnBoardingPage());

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnBoardingCubit, OnBoardingState>(
      builder: (context, state) {
        return IntroductionScreen(
          pages: [
            PageViewModel(
              titleWidget: SoulmateLogo(),
              image: Column(),
              bodyWidget: Text(
                'Keep your favorites in one place',
                style: TextStyle(fontSize: 18),
              ),
            ),
            PageViewModel(
              image: Column(),
              title: 'Login into social media',
              bodyWidget: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CachedNetworkImage(
                            imageUrl:
                                "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/VK.com-logo.svg/480px-VK.com-logo.svg.png",
                            width: 40),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text('More coming soon...'),
                    )
                  ],
                ),
              ),
            ),
            PageViewModel(
                image: Column(),
                title: 'Scroll posts and save your favorites',
                body: 'Keep on device or sync with cloud')
          ],
          dotsDecorator: DotsDecorator(color: Colors.amber),
          showNextButton: true,
          next: const Text('Next'),
          onDone: () => context.read<OnBoardingCubit>().complete(),
          done: const Text('Done'),
        );
      },
      listener: (context, state) {
        if (state.isCompleted) {
          Navigator.of(context).pushAndRemoveUntil(FavoritesPage.route(), (route) => false);
        }
      },
    );
  }
}
