import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';
import 'package:surya_mart_v1/presentation/page/signin_page.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();

  bool visibility = true;

  String? message;

  bool isLoading = false;

  Future<bool> register() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Auth()
          .signUp(
              email: emailController.text, password: passwordController.text)
          .then((value) => print('UID nya : ${Auth().currentUser?.uid}'));
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
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
        //print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
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
        //print('The account already exists for that email.');
      } else {
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      //print('Eror nya disini : $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
          onWillPop: ()async {
            if (isLoading) {
              return false;
            } else {
              return true;
            }
          },
          child: Scaffold(
      body:isLoading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
Row(children:[
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
              'Create Account',
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: Colors.white),),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => const SigninPage(),
                      ),
                    );
                  },
                  child: Text('Sign In',style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.lightBlueAccent),),
                ),
              ],
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    ),
  )
]),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKeyValue,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Name',style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isNotEmpty && value.length > 2) {
                                return null;
                              } else if (value.length < 5 && value.isNotEmpty) {
                                return 'Nama anda terlalu singkat!';
                              } else {
                                return 'Tidak boleh kosong!';
                              }
                            },
                            style: GoogleFonts.poppins(),
                            controller: usernameController,
                            decoration: InputDecoration(
                              hintText: "Syana Mutia",
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
                        Text('E-mail',style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isNotEmpty && value.length > 2) {
                                return null;
                              } else if (value.length < 5 && value.isNotEmpty) {
                                return 'Email anda terlalu singkat!';
                              } else {
                                return 'Tidak boleh kosong!';
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
                        Text('Password',style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            obscureText: visibility,
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
                                      ? const Icon(Icons.visibility_outlined)
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
                              contentPadding: const EdgeInsets.only(
                                  left: 24, top: 18, bottom: 18, right: 24),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text('Confirm Password',style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,),),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TextFormField(
                            obscureText: visibility,
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
                                      ? const Icon(Icons.visibility_outlined)
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
                              contentPadding: const EdgeInsets.only(
                                  left: 24, top: 18, bottom: 18, right: 24),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all(
                                            const EdgeInsets.only(top: 18, bottom: 18)),
                                        minimumSize: MaterialStateProperty.all<Size>(
                                            const Size(350, 0)),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0XFFFFC33A)),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: const BorderSide(
                                                    color: Color(0XFFFFC33A))))),
                                    child: Text(
                                      'Create Account',
                                      style: GoogleFonts.poppins(
                                          color: Colors.grey.shade800,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () {
                                      if (_formKeyValue.currentState!.validate()) {
                                        register().then((value) {
                                          if (value) {

                                            FirebaseFirestore firestore =
                                                FirebaseFirestore.instance;
                                            CollectionReference user =
                                            firestore.collection('users');

                                            user.add({
                                              'displayName': usernameController.text,
                                              'uid': Auth().currentUser?.uid,
                                              'createdAt': FieldValue.serverTimestamp(),
                                              'phone': '',
                                              'poin': 0,
                                              'shoppingCart': 0,
                                              'profilePicture': '',
                                            }).whenComplete((){
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (_) => const BottomNavbar(
                                                      currentIndex: 0,
                                                    )),
                                              );
                                            });
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
              ]),
      ),
    ),
        ));
  }
}
