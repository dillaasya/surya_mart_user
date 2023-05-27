import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';
import 'package:surya_mart_v1/presentation/page/introduction_page.dart';
import 'package:surya_mart_v1/presentation/page/splash_page.dart';
import 'package:firebase_core/firebase_core.dart';

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: SplashPage(),
            debugShowCheckedModeBanner: false,
            title: 'Suryamart',
          );
        } else {
          return StreamBuilder(
            stream: Auth().authChanges,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return MaterialApp(
                  home: BottomNavbar(
                    currentIndex: 0,
                  ),
                  title: 'Suryamart',
                  debugShowCheckedModeBanner: false,
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  home: Center(
                    child: SafeArea(
                      child: Scaffold(
                        body: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  ),
                  debugShowCheckedModeBanner: false,
                  title: 'Suryamart',
                );
              } else {
                return const MaterialApp(
                  home: IntroductionPage(),
                  debugShowCheckedModeBanner: false,
                  title: 'Suryamart',
                );
              }
            },
          );
        }
      },
    );
  }
}
