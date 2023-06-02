import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';
import 'package:surya_mart_v1/presentation/page/checkout_page.dart';

import 'package:surya_mart_v1/presentation/widget/cart_card.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  getIdUserForCart() {
    String idUser = Auth().currentUser!.uid;

    FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: idUser)
        .get()
        .then((value) {
      setState(() {
        idDocUser = value.docs.first.id;
        poinUser = value.docs.first.data()['poin'];
      });
    });
  }

  Future<bool> addressCek(String idUser) {
    Future<bool> x = FirebaseFirestore.instance
        .collection('users')
        .doc(idUser)
        .collection('address')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    });

    return x;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getIdUserForCart();
  }

  String? idDocUser;
  int poinUser = 0;
  bool isButtonDisabled = false;

  @override
  Widget build(BuildContext context) {
    var cartUser = FirebaseFirestore.instance
        .collection('users')
        .doc(idDocUser)
        .collection('cart');

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            title: Text('Cart',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16)),
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: cartUser.snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var x = snapshot.data?.docs[index];
                          return CartCard(
                              cartUser: cartUser, x: x, idDocUser: idDocUser);
                        },
                      );
                    } else {
                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/img4.png',
                              width: 200,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Oops, your shopping cart is empty!',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            )
                          ],
                        ),
                      );
                    }
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text('EROR'),
                    );
                  }
                },
              ),
            ),
          ),
          bottomNavigationBar: StreamBuilder(
            stream: cartUser.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                var listData = snapshot.data!.docs.toList();

                if (listData.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(top: 18, bottom: 18)),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(350, 0)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0XFFFFC33A)),
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
                          'Shop now',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade800,
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                                builder: (_) => const BottomNavbar(
                                      currentIndex: 1,
                                    )),
                          );
                        }),
                  );
                } else {
                  num total = 0;
                  num totalWeight = 0;

                  for (var i = 0; i < listData.length; i++) {

                    var tempWeight = listData[i].get('subWeight');
                    var temp =
                        listData[i].get('qty') * listData[i].get('price');
                    total = total + temp;
                    totalWeight = totalWeight+tempWeight;
                  }
                  return BottomAppBar(
                    child: SizedBox(
                      height: 80,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'TOTAL',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Rp ${total.toString()}',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.redAccent),
                                ),
                              ],
                            )),
                            Expanded(
                              child: Container(
                                height: 50,
                                //width: 160,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orangeAccent),
                                child: TextButton(
                                  onPressed: () {
                                    addressCek(idDocUser!).then((value) {
                                      if (value) {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return CheckoutPage(
                                            totalWeight: totalWeight,
                                            poinUser: poinUser,
                                            total: total,
                                            idUser: idDocUser.toString(),
                                          );
                                        }));
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                                  actionsAlignment:
                                                      MainAxisAlignment.center,
                                                  title: Text(
                                                    "Warning!",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  content: Text(
                                                    "You have not registered a shipping address, add a new address on the Profile > Shipping Address menu",
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      color: Colors.black,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                        Navigator.of(context)
                                                            .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (_) =>
                                                                  const BottomNavbar(
                                                                    currentIndex:
                                                                        2,
                                                                  )),
                                                        );
                                                      },
                                                      child: Text(
                                                        "Add new address",
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w300,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ));
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Checkout',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              } else {
                return const Text('EROR');
              }
            },
          )),
    );
  }
}
