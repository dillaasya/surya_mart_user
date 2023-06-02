import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/cart_page.dart';

class AddToCart extends StatefulWidget {
  final String id;
  final String name;
  final String? image;
  final int weight;
  final int price;

  const AddToCart({
    required this.id,
    required this.name,
    required this.image,
    required this.weight,
    required this.price,
    Key? key,
  }) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  int qty = 1;
  bool added = false;

  getIdUserForCart() {
    String idUser = Auth().currentUser!.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: idUser)
        .get()
        .then((value) => value.docs.first.id);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8)),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: widget.image == null
                              ? const Icon(Icons.image_not_supported_outlined)
                              : Image.network(widget.image.toString()),
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
                                widget.name,
                                maxLines: 1,
                                overflow: TextOverflow.clip,
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                'Rp ${widget.price}',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300),
                              ),
                            ]),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.close))
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          qty++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        qty.toString(),
                      ),
                    ),
                    IconButton(
                      onPressed: qty == 1
                          ? null
                          : () {
                              setState(() {
                                qty--;
                              });
                            },
                      icon: const Icon(Icons.remove),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: added == false
                          ? Colors.orangeAccent
                          : Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: TextButton(
                      onPressed: added == false
                          ? () async {
                              setState(() {
                                added = true;
                              });
                              var id = await getIdUserForCart();

                              String? x = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(id)
                                  .collection('cart')
                                  .where('productId', isEqualTo: widget.id)
                                  .get()
                                  .then((value) {
                                if (value.size == 1) {
                                  return value.docs.first.id;
                                } else {
                                  return null;
                                }
                              });

                              if (x != null) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(id)
                                    .collection('cart')
                                    .doc(x)
                                    .update({
                                  'qty': FieldValue.increment(qty),
                                  'subWeight':
                                      FieldValue.increment(widget.weight * qty),
                                  'subPrice':
                                      FieldValue.increment(widget.price * qty),
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return const CartPage();
                                    }),
                                  );
                                });
                              } else if (x == null) {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(id)
                                    .collection('cart')
                                    .add({
                                  'productId': widget.id,
                                  'price': widget.price,
                                  'subPrice': widget.price * qty,
                                  'qty': qty,
                                  'weight': widget.weight,
                                  'subWeight': widget.weight * qty,
                                  'productName': widget.name,
                                  'picture': widget.image,
                                }).whenComplete(() async {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(id)
                                      .update({
                                    'shoppingCart': FieldValue.increment(1)
                                  });
                                }).whenComplete(() {
                                  setState(() {
                                    added = false;
                                  });
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return const CartPage();
                                    }),
                                  );
                                });
                              } else {
                                const Center(child: Text('EROR'));
                              }
                            }
                          : null,
                      child: Text(
                        'Add',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
