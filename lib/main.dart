import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:surya_mart_v1/presentation/page/introduction_page.dart';
import 'package:surya_mart_v1/presentation/page/splash_page.dart';

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(const Duration(seconds: 3));
  }
}

void main() {WidgetsFlutterBinding.ensureInitialized();
SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:  Init.instance.initialize(),
      builder: (context, AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: SplashPage(),
            debugShowCheckedModeBanner: false,
          );
        } else {
          return MaterialApp(
            home: IntroductionPage(),
            debugShowCheckedModeBanner: false,
          );
        }
      },
    );
  }
}




