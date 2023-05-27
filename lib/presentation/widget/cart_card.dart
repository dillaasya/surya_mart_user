import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/detail_page.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cartUser,
    required this.x,
    required this.idDocUser,
  }) : super(key: key);

  final CollectionReference<Map<String, dynamic>> cartUser;
  final QueryDocumentSnapshot<Map<String, dynamic>>? x;
  final String? idDocUser;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(motion: const ScrollMotion(), children: [
        SlidableAction(
          onPressed: (context) {
            cartUser.doc(x?.id).delete();
            FirebaseFirestore.instance
                .collection('users')
                .doc(idDocUser)
                .update({'shoppingCart': FieldValue.increment(-1)});
          },
          backgroundColor: Colors.redAccent,
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ]),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailPage(
              idProduct: x?.data()['productId'],
              category: x?.data()['category'],
              stockProduct: x?.data()['stock'],
            );
          }));
        },
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(8)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: x!.data()['picture'] == null
                        ? const Icon(Icons.image_not_supported_outlined)
                        : Image.network(x!.data()['picture']),
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
                          '${x?.get('productName')}',
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Rp ${x?.get('price')}',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w300),
                        ),
                      ]),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        cartUser.doc(x?.id).update({
                          'qty': FieldValue.increment(1),
                          'subWeight':
                              FieldValue.increment(x?.data()['weight']),
                          'subPrice': FieldValue.increment(x?.data()['price'])
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('${x?.get('qty')}'),
                    ),
                    IconButton(
                      onPressed: x?.get('qty') == 1
                          ? null
                          : () {
                              cartUser.doc(x?.id).update({
                                'qty': FieldValue.increment(-1),
                                'subWeight': FieldValue.increment(
                                    -(x?.data()['weight'])),
                                'subPrice':
                                    FieldValue.increment(-(x?.data()['price']))
                              });
                            },
                      icon: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
