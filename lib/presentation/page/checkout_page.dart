import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:surya_mart_v1/presentation/page/choose_address_page.dart';
import 'package:surya_mart_v1/presentation/page/success_order_page.dart';

class CheckoutPage extends StatefulWidget {
  final String idUser;

  const CheckoutPage({required this.idUser, Key? key}) : super(key: key);

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
    //print('berhasil hapus produk $id');
  }

  Future<void> updateStockEachProduct() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('cart')
        .get()
        .then((value) {
      for (var element in value.docs) {
        /*print(
            'nama produk : ${element.data()['productName']} id produk : ${element.data()['productID']} qty : ${element.data()['qty']}');*/
        updateStock(element.data()['productId'], element.data()['qty']);
      }
    });
  }

  num totalWeight = 0;
  num totalPrice = 0;
  String? idOrder;
  String? shippingAddress;
  var listCart = [];

  Future<void> saveOrder() async {
    await deleteAllCart().whenComplete(() {
      FirebaseFirestore.instance.collection('users').doc(widget.idUser).update({
        'shoppingCart': 0,
      });
    }).whenComplete(() {
      FirebaseFirestore.instance.collection('orders').add({
        'dateOrder': FieldValue.serverTimestamp(),
        'paymentMethod': 'COD',
        'shippingAddress': shippingAddress,
        'statusOrder': 'PACKED',
        'totalPrice': totalPrice,
        'userId': widget.idUser,
        'cordinatAddress': const GeoPoint(0, 0),
        'productItem': listCart,
        'isReviewed': false,
        'totalWeight': totalWeight,
      });
    });

    //update sold dari semua produk yang terjual
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
                onTap: (){
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) {
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
                    padding: const EdgeInsets.only(left:20, right:20,bottom:20, top:10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined),
                        const SizedBox(width:4),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Alamat Pengiriman',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                                    const SizedBox(height:8),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                      StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(widget.idUser)
                                            .collection('address')
                                            .where('isSelected', isEqualTo: true).snapshots(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                              child: CircularProgressIndicator(),
                                            );
                                          } else if (snapshot.connectionState ==
                                              ConnectionState.active) {


                                            if (snapshot.data!.docs.isNotEmpty) {
                                              var x = snapshot.data!.docs.first;
                                              shippingAddress = x.data()['fullAddress'] +
                                                  ' ' +
                                                  x.data()['detailAddress'] +
                                                  ' ' +
                                                  x.data()['city'] +
                                                  ' ' +
                                                  x.data()['province'] +
                                                  ' ' +
                                                  x.data()['codeNumber'].toString();

                                              return Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(x.data()['recipientName'],style: GoogleFonts.poppins(fontWeight: FontWeight.w400),),
                                                  Text((x.data()['phone']).toString(),style: GoogleFonts.poppins(fontWeight: FontWeight.w300),),
                                                  Text(
                                                    x.data()['fullAddress'],
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 3,
                                                    style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
                                                  ),
                                                  Text((x.data()['codeNumber'])
                                                      .toString()),
                                                ],
                                              );
                                            }else{
                                              return Center(
                                                child: Text('Tidak ada alamat yang dipilih',style:
                                                GoogleFonts.poppins(fontWeight: FontWeight.w400),),
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
                              'Estimasi Pengiriman',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              DateFormat.yMMMEd().format(DateTime.now()),
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                                'Maksimal 1 jam setelah pembayaran selama jam operasional (09.00 - 15.00)',
                              style: GoogleFonts.poppins(fontWeight: FontWeight.w300),)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8,),
              Container(
                color:Colors.white,
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
                                        border: Border.all(width: 0.5, color: Colors.grey),
                                          borderRadius: BorderRadius.circular(8)
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: x.data()['picture'] == null
                                            ? const Icon(Icons.image_not_supported_outlined)
                                            : Image.network(x.data()['picture']),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${x.get('productName')}',
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                              style:
                                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                                            ),
                                            Text('Rp ${x.get('price')} x${x.data()['qty']}',style:
                                            GoogleFonts.poppins(fontWeight: FontWeight.w300),),
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
              const SizedBox(height: 8,),
              Container(
                color:Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [

                          const Icon(Icons.credit_card_rounded),
                          const SizedBox(width: 4,),
                          Text('Metode Pembayaran',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                        ],
                      ),
                      Expanded(child: Text('COD',style: GoogleFonts.poppins(fontWeight: FontWeight.w300,),textAlign: TextAlign.end,)),
                    ],
                  ),
                ),
              ),const SizedBox(height: 8,),
              Container(
                color:Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Rincian Pembayaran', style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                      const SizedBox(height: 10,),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.idUser)
                            .collection('cart')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (snapshot.connectionState ==
                              ConnectionState.active) {
                            var listData = snapshot.data!.docs.toList();

                            for (var i = 0; i < listData.length; i++) {
                              var temp = listData[i].get('subPrice');
                              var weight = listData[i].get('subWeight');

                              totalPrice = totalPrice + temp;
                              totalWeight = totalWeight + weight;
                            }

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('SubTotal Produk',style: GoogleFonts.poppins(fontWeight: FontWeight.w300),),
                                    Text('Biaya Pengiriman',style: GoogleFonts.poppins(fontWeight: FontWeight.w300),),
                                    Text('Total Belanja',style: GoogleFonts.poppins(fontWeight: FontWeight.w500),),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Rp ${totalPrice.toString()}',style: GoogleFonts.poppins(fontWeight: FontWeight.w300),),
                                    Text('Rp 0',style: GoogleFonts.poppins(fontWeight: FontWeight.w300),),
                                    Text('Rp ${totalPrice.toString()}',style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color: Colors.redAccent),),
                                  ],
                                )
                              ],
                            );
                          } else {
                            return const Text('eror');
                          }
                        },
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
                  child: Text('Buat Pesanan',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500, color:Colors.black),),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
