import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';

class SuccessOrderPage extends StatefulWidget {
  final String idUser;
  const SuccessOrderPage({required this.idUser, Key? key}) : super(key: key);

  @override
  State<SuccessOrderPage> createState() => _SuccessOrderPageState();
}

class _SuccessOrderPageState extends State<SuccessOrderPage> {
  Future<void> updateMainAddress(String id) async {
    //print('panggil delete satu item address');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('address')
        .doc(id)
        .update({'isSelected': false});
  }

  Future<void> updateAllAddress() async {
    //print('panggil delete all address');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('address')
        .where('isSelected', isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        updateMainAddress(element.id);
      }
    });

    //print('selesai delete all address');
  }

  Future<String?> getIdPrimaryAddress() async {
    String? id;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('address')
        .where('isPrimary', isEqualTo: true)
        .get()
        .then((value) {
      id = value.docs.first.id;
    });
    return id;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        const shouldPop = false;
        return shouldPop;
      },
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/img3.png',
                  width: 200,
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                      'Pesanan anda berhasil dibuat! Update informasi status pesanan pada menu Profile > Order History',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10, bottom: 10, left: 20, right: 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.only(top: 18, bottom: 18),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0XFFFFC33A),
                              ),
                              shape:
                                  MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: const BorderSide(
                                    color: Color(0XFFFFC33A),
                                  ),
                                ),
                              ),
                            ),
                            child: Text(
                              'Okay',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey.shade800,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () async {
                              var idPrimaryAddress = await getIdPrimaryAddress();
                              //set kembali alamat primary jadi selected
                              updateAllAddress().whenComplete(() {
                                if (mounted) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(widget.idUser)
                                      .collection('address')
                                      .doc(idPrimaryAddress)
                                      .update({'isSelected': true}).whenComplete(() {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (_) => const BottomNavbar(
                                            currentIndex: 2,
                                          )),
                                    );
                                  });
                                }
                              });

                            }),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
