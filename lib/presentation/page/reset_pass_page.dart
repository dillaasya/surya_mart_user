import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/success_reset_page.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  String? message;

  bool isDialogDone = false;

  Future<bool> reset() async {
    setState(() {
      isLoading = true;
    });
    try {
      await Auth().resetPass(email: emailController.text);

      setState(() {
        isLoading = true;
      });
      return true;
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            content: Text(
              e.message.toString(),
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          );
        },
      );

      setState(() {
        isLoading = false;
      });
      return false;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
          child: isLoading
              ? const Scaffold(body: Center(child: CircularProgressIndicator()))
              : Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
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
                                        'Reset Password',
                                        style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        'Enter your email addreess and we will send you link to reset password',
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
                          ],
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
                                const SizedBox(
                                  height: 20,
                                ),
                                const Text('E-mail'),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: TextFormField(
                                    validator: (value) {
                                      if (value!.isNotEmpty &&
                                          value.length > 2) {
                                        return null;
                                      } else if (value.length < 5 &&
                                          value.isNotEmpty) {
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
                                          left: 24,
                                          top: 18,
                                          bottom: 18,
                                          right: 24),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Row(children:[Expanded(child:ElevatedButton(
                                      style: ButtonStyle(
                                          padding: MaterialStateProperty.all(
                                              const EdgeInsets.only(
                                                  top: 18, bottom: 18)),
                                          minimumSize: MaterialStateProperty.all<Size>(
                                              const Size(350, 0)),
                                          backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              const Color(0XFFFFC33A)),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(18.0),
                                                  side: const BorderSide(color: Color(0XFFFFC33A))))),
                                      child: Text(
                                        'Reset Password',
                                        style: GoogleFonts.poppins(
                                            color: Colors.grey.shade800,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      onPressed: () {
                                        if (mounted) {
                                          reset().then((value) {
                                            if (value) {
                                              Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (_) => const SuccessResetPage()),
                                              );
                                            } else {
                                              //print('nilai reset : $value');
                                            }
                                          });
                                        }
                                      }),),]),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          onWillPop: () async {
            if (isLoading) {
              return false;
            } else {
              return true;
            }
          }),
    );
  }
}
