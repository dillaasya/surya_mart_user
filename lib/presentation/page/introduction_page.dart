import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'signin_page.dart';

class IntroductionPage extends StatelessWidget {
  const IntroductionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'EASY SHOPPING',
            body:
                'Original with 1000 product from a lot of  different brand accros the world. buy so easy with just simple step then your item will send it.',
            image: buildImage('assets/images/img1.png'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'FREE SHIPPING',
            body:
                'Original with 1000 product from a lot of  different brand accros the world. buy so easy with just simple step then your item will send it.',
            image: buildImage('assets/images/img2.png'),
            decoration: getPageDecoration(),
          ),
          PageViewModel(
            title: 'FAST DELIVERY',
            body:
                'Original with 1000 product from a lot of  different brand accros the world. buy so easy with just simple step then your item will send it.',
            image: buildImage('assets/images/img3.png'),
            decoration: getPageDecoration(),
          ),
        ],
        done:  Icon(
          Icons.arrow_forward,
          size: 24,
          color: Color(0xffFFC33A),
        ),
        onDone: () => goToHome(context),
        showSkipButton: true,
        skip: Text(
          'Skip',
          style: GoogleFonts.poppins(
              fontSize: 16,
              color: const Color(0xff4B5563),
              fontWeight: FontWeight.w400),
        ),
        onSkip: () => goToHome(context),
        next: const Icon(
          Icons.arrow_forward,
          size: 24,
          color: Color(0xffFFC33A),
        ),
        dotsDecorator: getDotDecoration(),
        onChange: (index) => debugPrint('Page $index selected'),
        dotsFlex: 0,
        nextFlex: 1,
        skipOrBackFlex: 1,
      ),
    );
  }

  void goToHome(context) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const SigninPage()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 250));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: const Color(0xFFBDBDBD),
        activeColor: Colors.grey.shade700,
        size: const Size(10, 10),
        activeSize: const Size(10, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        bodyTextStyle: const TextStyle(
          fontSize: 14,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w400,
        ),
        bodyPadding: const EdgeInsets.all(16).copyWith(bottom: 0),
        imagePadding: const EdgeInsets.only(top: 100, left: 24, right: 24),
        //pageColor: Colors.white,
      );
}
