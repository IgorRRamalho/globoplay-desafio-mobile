import 'package:flutter/material.dart';
import '../home/home_page.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});
  final String logo = 'assets/geral/globoplay_logo.png';

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(_createFadeRoute());
    });

    return Scaffold(
      backgroundColor: const Color(0xFF191919),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: 1.1,
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeInOut,
              child: Image.asset(
                logo,
                height: 280,
                width: 280,
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          ],
        ),
      ),
    );
  }

  PageRouteBuilder _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var opacityTween = Tween(begin: 0.0, end: 1.0).animate(animation);
        var scaleTween = Tween(begin: 1.05, end: 1.0).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        ));

        return FadeTransition(
          opacity: opacityTween,
          child: ScaleTransition(
            scale: scaleTween,
            child: child,
          ),
        );
      },
    );
  }
}
