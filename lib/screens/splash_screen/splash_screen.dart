import 'package:agrotech_app/screens/home_screen/home.dart';
import 'package:flame_splash_screen/flame_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreenGame extends StatefulWidget {
  static const route = '/';
  const SplashScreenGame({super.key});

  @override
  State<SplashScreenGame> createState() => _SplashScreenGameState();
}

class _SplashScreenGameState extends State<SplashScreenGame> {
  late FlameSplashController controller;
  @override
  void initState() {
    super.initState();
    controller = FlameSplashController(
      fadeInDuration: const Duration(seconds: 1),
      fadeOutDuration: const Duration(milliseconds: 250),
      waitDuration: const Duration(seconds: 2),
      autoStart: true,
    );
  }

  @override
  void dispose() {
    controller.dispose(); // dispose it when necessary
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlameSplashScreen(
        showAfter: (context) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              Image.asset(
                'assets/images/logo-primary.png',
                width: 200,
              ),
              const Text(
                'AgroTech',
                style: TextStyle(
                    fontFamily: 'MuseoModerno',
                    fontSize: 32,
                    fontWeight: FontWeight.w700),
              ),
              Lottie.asset('assets/animations/loader.json', width: 150),
            ],
          );
        },
        theme: FlameSplashTheme.white,
        onFinish: (context) =>
            Navigator.pushReplacementNamed(context, HomeScreen.route),
        controller: controller,
      ),
    );
  }
}
