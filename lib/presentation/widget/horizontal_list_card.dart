import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/detail_page.dart';

class ListCard extends StatefulWidget {
  final String? id;

  const ListCard(this.id, {Key? key}) : super(key: key);

  @override
  State<ListCard> createState() => _ListCardState();
}

class _ListCardState extends State<ListCard> {
  String? name, description, price, weight, image, category, id;
  int? stock;
  getProductById() {
    FirebaseFirestore.instance
        .collection('products')
        .doc(widget.id)
        .get()
        .then((value) {
      if (mounted) {
        setState(() {
          id = value.id;
          name = value.data()?['name'];
          description = value.data()?['description'];
          price = value.data()?['price'].toString();
          weight = value.data()?['weight'].toString();
          image = value.data()?['image'];
          category = value.data()?['category'];
          stock = value.data()?['stock'];
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getProductById();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetailPage(
              idProduct: widget.id,
              category: category,
              stockProduct: stock,
            );
          }));
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: 120,
            child: stock == 0
                ? Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 120,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(14),
                                  bottom: Radius.circular(14)),
                              child: image == null
                                  ? const Icon(
                                      Icons.image_not_supported_outlined)
                                  : Image.network(
                                      image ?? '',
                                      fit: BoxFit.scaleDown,
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 8, right: 8),
                            child: Text(
                              name.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8, bottom: 8, top: 4),
                            child: Text(
                              'Rp ${price.toString()}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.redAccent,
                                  fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        height: 120,
                        child: Center(
                          child: Text(
                            'Not available',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                        ),
                      )
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                          child: image == null
                              ? Container(
                                  color: Colors.grey.shade300,
                                  child: const Icon(
                                      Icons.image_not_supported_outlined),
                                )
                              : Image.network(
                                  image ?? '',
                                  fit: BoxFit.scaleDown,
                                ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                        child: Text(
                          name.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, bottom: 8, top: 4),
                        child: Text(
                          'Rp ${price.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              color: Colors.redAccent,
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }
}
