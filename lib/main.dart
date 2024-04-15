import 'package:agrotech_app/screens/analysis_screen/analysis_screen.dart';
import 'package:agrotech_app/screens/home_screen/home.dart';
import 'package:agrotech_app/screens/result_screen/result_screen.dart';
import 'package:agrotech_app/screens/splash_screen/splash_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
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
      theme: FlexThemeData.light(
        fontFamily: 'Quicksand',
        colors: const FlexSchemeColor(
          primary: Color(0xff055c34),
          // primaryVariant: Color(0xff022c19),
          secondary: Color(0xff044426),
          // secondaryVariant: Color(0xff01180e),
          appBarColor: Color(0xff01180e),
          error: Color(0xffb00020),
        ),
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 18,
        appBarStyle: FlexAppBarStyle.primary,
        appBarOpacity: 0.95,
        appBarElevation: 1,
        transparentStatusBar: true,
        tabBarStyle: FlexTabBarStyle.forAppBar,
        tooltipsMatchBackground: true,
        swapColors: false,
        lightIsWhite: false,
        // useSubThemes: true,
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use playground font, add GoogleFonts package and uncomment:
        // fontFamily: GoogleFonts.notoSans().fontFamily,
        subThemesData: const FlexSubThemesData(
          useTextTheme: true,
          fabUseShape: true,
          interactionEffects: true,
          bottomNavigationBarElevation: 0,
          bottomNavigationBarOpacity: 0.95,
          navigationBarOpacity: 0.95,
          // navigationBarMutedUnselectedText: true,
          navigationBarMutedUnselectedIcon: true,
          inputDecoratorIsFilled: true,
          inputDecoratorBorderType: FlexInputBorderType.outline,
          inputDecoratorUnfocusedHasBorder: true,
          blendOnColors: true,
          blendTextTheme: true,
          popupMenuOpacity: 0.95,
        ),
      ),

// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

      initialRoute: SplashScreenGame.route,
      routes: {
        SplashScreenGame.route: (context) => const SplashScreenGame(),
        HomeScreen.route: (context) => const HomeScreen(),
        ResultScreen.route: (context) => const ResultScreen(),
        AnalysisScreen.route: (context) => const AnalysisScreen()
      },
    );
  }
}
