import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';
import 'package:surya_mart_v1/presentation/page/reset_pass_page.dart';
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

  String? message;

  bool isLoading = false;

  Future<bool> login() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Auth().signIn(
          email: emailController.text, password: passwordController.text);
      return true;
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e.message.toString()),
          );
        },
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const SafeArea(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : SafeArea(
            child: WillPopScope(
            onWillPop: () async {
              if (isLoading) {
                return false;
              } else {
                return true;
              }
            },
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff0062CD),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 40, left: 20, right: 20, bottom: 20),
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
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Please fill E-mail & password to login your app account.',
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ]),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKeyValue,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'E-mail',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                validator: (value) {
                                  if (value!.isNotEmpty && value.length > 2) {
                                    return null;
                                  } else if (value.length < 5 &&
                                      value.isNotEmpty) {
                                    return 'Please enter a valid email';
                                  } else {
                                    return 'It can\'t be empty!';
                                  }
                                },
                                style: GoogleFonts.poppins(),
                                controller: emailController,
                                decoration: InputDecoration(
                                  hintText: "example@gmail.com",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
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
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Password',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TextFormField(
                                obscureText: visibility,
                                validator: (value) {
                                  if (value!.isNotEmpty && value.length > 2) {
                                    return null;
                                  } else {
                                    return 'It can\'t be empty!';
                                  }
                                },
                                style: GoogleFonts.poppins(),
                                controller: passwordController,
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(
                                      left: 24, top: 18, bottom: 18, right: 24),
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          visibility = !visibility;
                                        });
                                      },
                                      icon: visibility == false
                                          ? const Icon(
                                              Icons.visibility_outlined)
                                          : const Icon(
                                              Icons.visibility_off_outlined)),
                                  hintText: "********",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const ResetPasswordPage()),
                                    );
                                  },
                                  child: Text(
                                    'Forgot Password?',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.lightBlueAccent),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30,
                                bottom: 10,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all(
                                                const EdgeInsets.only(
                                                    top: 18, bottom: 18)),
                                            minimumSize:
                                                MaterialStateProperty.all<Size>(
                                                    const Size(350, 0)),
                                            backgroundColor:
                                                MaterialStateProperty.all<Color>(
                                                    const Color(0XFFFFC33A)),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(18.0),
                                                    side: const BorderSide(color: Color(0XFFFFC33A))))),
                                        child: Text(
                                          'Login Now',
                                          style: GoogleFonts.poppins(
                                              color: Colors.grey.shade800,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        onPressed: () {
                                          if (_formKeyValue.currentState!
                                              .validate()) {
                                            login().then((value) {
                                              if (value) {
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                      builder: (_) =>
                                                          const BottomNavbar(
                                                            currentIndex: 0,
                                                          )),
                                                );
                                              }
                                            });
                                          }
                                        }),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account yet?',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SignupPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            color: Colors.lightBlueAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
  }
}
