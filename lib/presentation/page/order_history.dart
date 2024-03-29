import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/add_review.dart';
import 'package:surya_mart_v1/presentation/page/detail_order.dart';

class OrderHistory extends StatefulWidget {
  final String id;

  const OrderHistory({required this.id, Key? key}) : super(key: key);

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  var defaultTab = ['ALL'];

  var listHeaderTab = ['PACKED', 'SHIPPED', 'SUCCEED', 'CANCELLED'];

  @override
  Widget build(BuildContext context) {
    var listTab = defaultTab + listHeaderTab;

    var viewTabDefault = <Widget>[
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: widget.id)
            .orderBy('dateOrder', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var x = snapshot.data!.docs[index];

                  Timestamp t = x.data()['dateOrder'];
                  DateTime d = t.toDate();

                  List z = x.data()['productItem'];

                  Map first = z.first;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailOrder(
                                    idUser: x.data()['userId'],
                                    listCart: x.data()['productItem'],
                                    status: x.data()['statusOrder'],
                                    idOrder: x.id,
                                    isReviewed: x.data()['isReviewed']);
                              }));
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      d.toString(),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      x.data()['statusOrder'],
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 0.5, color: Colors.grey)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: first['picture'] == null
                                            ? const Icon(Icons
                                                .image_not_supported_outlined)
                                            : Image.network(
                                                first['picture'],
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Center(
                                                    child: Text(
                                                      'No Internet',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 8),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${first['productName']}',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w300),
                                            maxLines: 1,
                                            overflow: TextOverflow.clip,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Rp ${first['price']} ',
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                'x${first['qty']}',
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                z.isEmpty
                                    ? Column(children: [
                                        const Divider(),
                                        Center(
                                          child: Text(
                                            'Show more products',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ])
                                    : Container(),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${z.length.toString()} products',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Row(children: [
                                      Text(
                                        'Total Spend ',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        'Rp ${x.data()['totalPrice'].toString()}',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.redAccent),
                                      )
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          if (x.data()['statusOrder'] == 'SUCCEED')
                            InkWell(
                              onTap: x.data()['isReviewed'] == false
                                  ? () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return AddReview(
                                              idOrder: x.id,
                                              idUser: x.data()['userId'],
                                              listCart:
                                                  x.data()['productItem']);
                                        },
                                      ));
                                    }
                                  : null,
                              child: x.data()['isReviewed'] == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.orangeAccent,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.rate_review_outlined,
                                              color: Colors.grey.shade800,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Leave a Review',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.rate_review_outlined,
                                              color: Colors.grey.shade800,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Reviewed',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            )
                          else if (x.data()['statusOrder'] == 'PACKED')
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(x.id)
                                    .update({
                                  'statusOrder': 'CANCELLED'
                                }).whenComplete(() {
                                  List<String> listIdProduct = [];
                                  List<int> listQtyProduct = [];
                                  for (var element in x['productItem']) {
                                    listIdProduct.add(element['productId']);
                                    listQtyProduct.add(element['qty']);
                                  }

                                  for (var i = 0;
                                      i < listIdProduct.length;
                                      i++) {
                                    FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(listIdProduct[i])
                                        .update({
                                      'stock': FieldValue.increment(
                                          listQtyProduct[i]),
                                      'sold': FieldValue.increment(
                                          -(listQtyProduct[i])),
                                    });
                                  }
                                });
                              },
                              child: x.data()['statusOrder'] == 'PACKED'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.redAccent,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Cancel Order',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : null,
                            )
                          else if (x.data()['statusOrder'] == 'SHIPPED')
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(x.id)
                                    .update({
                                  'statusOrder': 'SUCCEED'
                                }).whenComplete(() {
                                  var jumlah = x.data()['totalPrice'] / 50000;

                                  if (jumlah > 0) {
                                    var subPoin = jumlah.floor() * 10;

                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.id)
                                        .update({
                                      'poin': FieldValue.increment(subPoin)
                                    }).whenComplete(() {
                                      showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              title: Text(
                                                "Congratulations!",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Text(
                                                "You have earned $subPoin points",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          });
                                    });
                                  } else {}
                                });
                              },
                              child: x.data()['statusOrder'] == 'SHIPPED'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Order Received',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          //Text(x.data()['productItem']),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No purchase history',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          } else {
            return const Text('eror');
          }
        },
      )
    ];

    var viewTabCategory = listHeaderTab.map<Widget>((e) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: widget.id)
            .where('statusOrder', isEqualTo: e)
            .orderBy('dateOrder', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data!.docs.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  var x = snapshot.data!.docs[index];

                  Timestamp t = x.data()['dateOrder'];
                  DateTime d = t.toDate();

                  List z = x.data()['productItem'];
                  Map first = z.first;

                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailOrder(
                                    idUser: x.data()['userId'],
                                    listCart: x.data()['productItem'],
                                    status: x.data()['statusOrder'],
                                    idOrder: x.id,
                                    isReviewed: x.data()['isReviewed']);
                              }));
                            },
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      d.toString(),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      x.data()['statusOrder'],
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.blue),
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              width: 0.5, color: Colors.grey)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: first['picture'] == null
                                            ? const Icon(Icons
                                                .image_not_supported_outlined)
                                            : Image.network(
                                                first['picture'],
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Center(
                                                    child: Text(
                                                      'No Internet',
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300,
                                                              fontSize: 8),
                                                    ),
                                                  );
                                                },
                                              ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${first['productName']}',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w300),
                                            overflow: TextOverflow.clip,
                                            maxLines: 1,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Rp ${first['price']} ',
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                              Text(
                                                'x${first['qty']}',
                                                style: GoogleFonts.poppins(
                                                    fontWeight:
                                                        FontWeight.w300),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                z.isEmpty
                                    ? Column(children: [
                                        const Divider(),
                                        Center(
                                          child: Text(
                                            'Show more products',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ])
                                    : Container(),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${z.length.toString()} products',
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Row(children: [
                                      Text(
                                        'Total Spend ',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w300),
                                      ),
                                      Text(
                                        'Rp ${x.data()['totalPrice'].toString()}',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w300,
                                            color: Colors.redAccent),
                                      )
                                    ]),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          if (x.data()['statusOrder'] == 'SUCCEED')
                            InkWell(
                              onTap: x.data()['isReviewed'] == false
                                  ? () {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return AddReview(
                                              idOrder: x.id,
                                              idUser: x.data()['userId'],
                                              listCart:
                                                  x.data()['productItem']);
                                        },
                                      ));
                                    }
                                  : null,
                              child: x.data()['isReviewed'] == false
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.orangeAccent,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.rate_review_outlined,
                                              color: Colors.grey.shade800,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Leave a Review',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.grey,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.rate_review_outlined,
                                              color: Colors.grey.shade800,
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              'Reviewed',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            )
                          else if (x.data()['statusOrder'] == 'PACKED')
                            InkWell(
                              onTap: () {
                                //update status order ke cancelled
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(x.id)
                                    .update({'statusOrder': 'CANCELLED'});
                              },
                              child: x.data()['statusOrder'] == 'PACKED'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.redAccent,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Cancel Order',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : null,
                            )
                          else if (x.data()['statusOrder'] == 'SHIPPED')
                            InkWell(
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('orders')
                                    .doc(x.id)
                                    .update({
                                  'statusOrder': 'SUCCEED'
                                }).whenComplete(() {
                                  var jumlah = x.data()['totalPrice'] / 50000;

                                  if (jumlah > 5) {
                                    var subPoin = jumlah.floor() * 10;
                                    FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.id)
                                        .update({
                                      'poin': FieldValue.increment(subPoin)
                                    }).whenComplete(() {
                                      showDialog(
                                          barrierDismissible: true,
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return AlertDialog(
                                              actionsAlignment:
                                                  MainAxisAlignment.center,
                                              title: Text(
                                                "Congratulations!",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              content: Text(
                                                "You have earned $subPoin points",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            );
                                          });
                                    });
                                  } else {}
                                });
                              },
                              child: x.data()['statusOrder'] == 'SHIPPED'
                                  ? Padding(
                                      padding: const EdgeInsets.only(top: 14),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green,
                                        ),
                                        height: 50,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Order Received',
                                              style: GoogleFonts.poppins(
                                                  color: Colors.grey.shade800,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  : null,
                            ),
                          //Text(x.data()['productItem']),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    'No purchase history',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
          } else {
            return const Text('eror');
          }
        },
      );
    }).toList();

    var viewTabAll = viewTabDefault + viewTabCategory;

    return SafeArea(
      child: DefaultTabController(
        length: listTab.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            title: Text(
              'Order History',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16),
            ),
            notificationPredicate: (ScrollNotification notification) {
              return notification.depth == 1;
            },
            scrolledUnderElevation: 2.0,
            bottom: TabBar(
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              isScrollable: true,
              tabs: listTab
                  .map((e) => Tab(
                        text: e,
                      ))
                  .toList(),
            ),
          ),
          body: TabBarView(children: viewTabAll),
        ),
      ),
    );
  }
}
