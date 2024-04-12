import 'package:agrotech_app/screens/home/home.dart';
import 'package:agrotech_app/screens/splashscreen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreenGame(),
        '/home': (context) => HomeScreen()
      },
    );
  }
}
