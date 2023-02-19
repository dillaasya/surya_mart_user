import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/signin_page.dart';

class SuccessPage extends StatelessWidget {
  const SuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/img2.png'),
            Text(
              'Your Account Has Been Successfully Created !',
              style: GoogleFonts.poppins(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0XFFFFC33A),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) =>SigninPage()),
                  );
                },
                child: Text(
                  'Go To Login',
                  style: GoogleFonts.poppins(
                      color: Colors.grey.shade800,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
