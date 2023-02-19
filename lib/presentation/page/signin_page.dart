import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';
import 'package:surya_mart_v1/presentation/page/signup_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool visibility = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      //backgroundColor: Colors.white,
      /*appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xff0062CD),
      ),*/
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [

            Container(
              decoration: BoxDecoration(
                color: Color(0xff0062CD),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top:40, left:20, right:20, bottom:20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome Back!',
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Please fill E-mail & password to login your app account.',
                      style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKeyValue,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text('E-mail'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isNotEmpty && value.length > 2) {
                            return null;
                          } else if (value.length < 5 && value.isNotEmpty) {
                            return 'Nama resep anda terlalu singkat!';
                          } else {
                            return 'Tidak boleh kosong!';
                          }
                        },
                        style: GoogleFonts.poppins(),
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "example@gmail.com",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffDCDCDC),
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 24, top: 18, bottom: 18, right: 24),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Password'),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: TextFormField(
                        obscureText: visibility,
                        validator: (value) {
                          if (value!.isNotEmpty && value.length > 2) {
                            return null;
                          } else if (value.length < 5 && value.isNotEmpty) {
                            return 'Nama resep anda terlalu singkat!';
                          } else {
                            return 'Tidak boleh kosong!';
                          }
                        },
                        style: GoogleFonts.poppins(),
                        controller: passwordController,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  visibility = !visibility;
                                });
                              },
                              icon: visibility == false
                                  ? Icon(Icons.visibility_outlined)
                                  : Icon(Icons.visibility_off_outlined)),
                          hintText: "********",
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.deepOrangeAccent,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xffDCDCDC),
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          contentPadding: const EdgeInsets.only(
                              left: 24, top: 18, bottom: 18, right: 24),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(value: (true), onChanged: (newValue) {}),
                              Text('Remember Me'),
                            ],
                          ),
                          Text('Forgot Password?')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.only(top: 18, bottom: 18)),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(350, 0)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0XFFFFC33A)),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: const BorderSide(
                                          color: Color(0XFFFFC33A))))),
                          child: Text(
                            'Login Now',
                            style: GoogleFonts.poppins(
                                color: Colors.grey.shade800,
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            /*if (mounted) {
                              setState(() {
                                postItem();

                              });
                            }*/
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const BottomNavbar()),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Belum punya akun?'),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SignupPage(),
                      ),
                    );
                  },
                  child: Text('Sign Up'),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
