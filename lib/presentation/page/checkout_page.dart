import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:surya_mart_v1/presentation/page/choose_address_page.dart';
import 'package:surya_mart_v1/presentation/page/success_order_page.dart';

class CheckoutPage extends StatefulWidget {
  final String idUser;
  final num total;
  final int poinUser;

  const CheckoutPage(
      {required this.poinUser,
      required this.idUser,
      required this.total,
      Key? key})
      : super(key: key);

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Future<void> deleteCartItem(String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('cart')
        .doc(id)
        .delete();
  }

  Future<void> deleteAllCart() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('cart')
        .get()
        .then((value) {
      for (var element in value.docs) {
        deleteCartItem(element.id);
      }
    });
  }

  Future<void> updateStock(String id, int qty) async {
    await FirebaseFirestore.instance.collection('products').doc(id).update({
      'stock': FieldValue.increment(-(qty)),
      'sold': FieldValue.increment(qty),
    });
  }

  Future<void> updateStockEachProduct() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('cart')
        .get()
        .then((value) {
      for (var element in value.docs) {
        updateStock(element.data()['productId'], element.data()['qty']);
      }
    });
  }

  num totalWeight = 0;
  num totalPrice = 0;
  String? idOrder;
  String? shippingAddress;
  var listCart = [];
  int poin = 0;
  int potonganPoin = 0;
  int ongkir = 0;

  Future<void> saveOrder() async {
    await deleteAllCart().whenComplete(() {
      FirebaseFirestore.instance.collection('users').doc(widget.idUser).update({
        'poin': FieldValue.increment(-poin),
        'shoppingCart': 0,
      });
    }).whenComplete(() {
      FirebaseFirestore.instance.collection('orders').add({
        'dateOrder': FieldValue.serverTimestamp(),
        'paymentMethod': 'COD',
        'shippingAddress': shippingAddress,
        'statusOrder': 'PACKED',
        'potongannPoin': potonganPoin,
        'subTotal': widget.total,
        'totalPrice': widget.total - potonganPoin,
        'deliveryFee': ongkir,
        'userId': widget.idUser,
        'cordinatAddress': const GeoPoint(0, 0),
        'productItem': listCart,
        'isReviewed': false,
        'totalWeight': totalWeight,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text('Checkout',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ChooseAddress(idUser: widget.idUser);
                  }));
                },
                child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 5, color: Colors.blue),
                      ),
                      color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Shipping Address',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const SizedBox(height: 8),
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(widget.idUser)
                                                .collection('address')
                                                .where('isSelected',
                                                    isEqualTo: true)
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else if (snapshot
                                                      .connectionState ==
                                                  ConnectionState.active) {
                                                if (snapshot
                                                    .data!.docs.isNotEmpty) {
                                                  var x =
                                                      snapshot.data!.docs.first;
                                                  shippingAddress = x.data()[
                                                          'fullAddress'] +
                                                      ' ' +
                                                      x.data()[
                                                          'detailAddress'] +
                                                      ' ' +
                                                      x.data()['city'] +
                                                      ' ' +
                                                      x.data()['province'] +
                                                      ' ' +
                                                      x
                                                          .data()['codeNumber']
                                                          .toString();

                                                  return Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        x.data()[
                                                            'recipientName'],
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400),
                                                      ),
                                                      Text(
                                                        (x.data()['phone'])
                                                            .toString(),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ),
                                                      Text(
                                                        x.data()['fullAddress'],
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 3,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                      ),
                                                      Text((x.data()[
                                                              'codeNumber'])
                                                          .toString()),
                                                    ],
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Text(
                                                      'No address selected',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                return const Text('eror');
                                              }
                                            },
                                          )
                                        ]),
                                  ],
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_right_rounded)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estimated Delivery',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              DateFormat.yMMMEd().format(DateTime.now()),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              'Maximum 1 hour after make an order during operating hours (09.00 - 20.00)',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(widget.idUser)
                        .collection('cart')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.active) {
                        listCart =
                            snapshot.data!.docs.map((e) => e.data()).toList();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var x = snapshot.data!.docs[index];

                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          //color: Colors.grey.shade200,
                                          border: Border.all(
                                              width: 0.5, color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: x.data()['picture'] == null
                                            ? const Icon(Icons
                                                .image_not_supported_outlined)
                                            : Image.network(
                                                x.data()['picture']),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${x.get('productName')}',
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              'Rp ${x.get('price')} x${x.data()['qty']}',
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        return const Text('eror');
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.credit_card_rounded),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            'Payment Method',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      Expanded(
                          child: Text(
                        'COD',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.end,
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Redeem Points',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You have ${widget.poinUser} points',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500, fontSize: 9),
                              ),
                              Text(
                                'Spend above Rp 10.000 and use at least 100 points to get a discount',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 9,
                                    color: Colors.orangeAccent),
                              ),
                            ],
                          )),
                          InkWell(
                            onTap: widget.poinUser >= 100
                                ? widget.total > 10000
                                    ? () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          context: context,
                                          builder: (context) {
                                            return SingleChildScrollView(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    InkWell(
                                                      onTap:
                                                          widget.poinUser >= 100
                                                              ? widget.total >=
                                                                      10000
                                                                  ? () {
                                                                      setState(
                                                                          () {
                                                                        poin =
                                                                            100;
                                                                        potonganPoin =
                                                                            10000;
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    }
                                                                  : () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content:
                                                                            Text(
                                                                          'You do not reach a minimum spend of Rp 10.000',
                                                                          style:
                                                                              GoogleFonts.poppins(
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                      ));
                                                                    }
                                                              : null,
                                                      child: Container(
                                                        color:
                                                            widget.poinUser >=
                                                                    100
                                                                ? Colors.blue
                                                                : Colors.grey,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            '100',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    InkWell(
                                                      onTap:
                                                          widget.poinUser >= 200
                                                              ? widget.total >=
                                                                      20000
                                                                  ? () {
                                                                      setState(
                                                                          () {
                                                                        poin =
                                                                            200;
                                                                        potonganPoin =
                                                                            20000;
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    }
                                                                  : () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content: Text(
                                                                            'You do not reach a minimum spend of Rp 20.000',
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.w400,
                                                                            )),
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                      ));
                                                                    }
                                                              : null,
                                                      child: Container(
                                                        color:
                                                            widget.poinUser >=
                                                                    200
                                                                ? Colors.blue
                                                                : Colors.grey,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            '200',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    InkWell(
                                                      onTap:
                                                          widget.poinUser >= 300
                                                              ? widget.total >=
                                                                      30000
                                                                  ? () {
                                                                      setState(
                                                                          () {
                                                                        poin =
                                                                            300;
                                                                        potonganPoin =
                                                                            30000;
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    }
                                                                  : () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content: Text(
                                                                            'You do not reach a minimum spend of Rp 30.000',
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.w400,
                                                                            )),
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                      ));
                                                                    }
                                                              : null,
                                                      child: Container(
                                                        color:
                                                            widget.poinUser >=
                                                                    300
                                                                ? Colors.blue
                                                                : Colors.grey,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            '300',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    InkWell(
                                                      onTap:
                                                          widget.poinUser >= 400
                                                              ? widget.total >=
                                                                      40000
                                                                  ? () {
                                                                      setState(
                                                                          () {
                                                                        poin =
                                                                            400;
                                                                        potonganPoin =
                                                                            40000;
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    }
                                                                  : () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content: Text(
                                                                            'You do not reach a minimum spend of Rp 40.000',
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.w400,
                                                                            )),
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                      ));
                                                                    }
                                                              : null,
                                                      child: Container(
                                                        color:
                                                            widget.poinUser >=
                                                                    400
                                                                ? Colors.blue
                                                                : Colors.grey,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            '400',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const Divider(),
                                                    InkWell(
                                                      onTap:
                                                          widget.poinUser >= 500
                                                              ? widget.total >=
                                                                      50000
                                                                  ? () {
                                                                      setState(
                                                                          () {
                                                                        poin =
                                                                            500;
                                                                        potonganPoin =
                                                                            50000;
                                                                        Navigator.pop(
                                                                            context);
                                                                      });
                                                                    }
                                                                  : () {
                                                                      Navigator.pop(
                                                                          context);
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(
                                                                        content: Text(
                                                                            'You do not reach a minimum spend of Rp 50.000',
                                                                            style:
                                                                                GoogleFonts.poppins(
                                                                              fontWeight: FontWeight.w400,
                                                                            )),
                                                                        duration:
                                                                            const Duration(seconds: 2),
                                                                      ));
                                                                    }
                                                              : null,
                                                      child: Container(
                                                        color:
                                                            widget.poinUser >=
                                                                    500
                                                                ? Colors.blue
                                                                : Colors.grey,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Text(
                                                            '500',
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    //Divider(),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }
                                    : null
                                : null,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: widget.poinUser > 100
                                    ? widget.total > 10000
                                        ? Colors.lightBlue.shade300
                                        : Colors.grey
                                    : Colors.grey,
                              ),
                              child: potonganPoin == 0
                                  ? Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        'Reedem',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '$poin Points',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
                      poin == 0
                          ? Container()
                          : Center(
                              child: Column(
                                children: [
                                  const Divider(),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        poin = 0;
                                        potonganPoin = 0;
                                      });
                                    },
                                    child: Text(
                                      'Cancel reedem',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.redAccent),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Details',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SubTotal Products',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                ' Points Discount',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                'Shipping Cost',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                'Total Spend',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Rp ${widget.total}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300),
                              ),
                              potonganPoin == 0
                                  ? Text(
                                      'Rp 0',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.redAccent),
                                    )
                                  : Text(
                                      '- Rp $potonganPoin',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.redAccent),
                                    ),
                              Text(
                                'Rp $ongkir',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                'Rp ${widget.total - potonganPoin}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.redAccent),
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Container(
                height: 50,
                //width: 160,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.orangeAccent),
                child: TextButton(
                  onPressed: () async {
                    await updateStockEachProduct().whenComplete(() {
                      saveOrder().whenComplete(
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return SuccessOrderPage(
                              idUser: widget.idUser,
                            );
                          }),
                        ),
                      );
                    });
                  },
                  child: Text(
                    'Make an order',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500, color: Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
