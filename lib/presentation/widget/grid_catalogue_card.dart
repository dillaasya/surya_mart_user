import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/detail_page.dart';

class GridCatalogueCard extends StatefulWidget {
  final String? id;

  const GridCatalogueCard(this.id, {Key? key}) : super(key: key);

  @override
  State<GridCatalogueCard> createState() => _GridCatalogueCardState();
}

class _GridCatalogueCardState extends State<GridCatalogueCard> {
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
          name = (value.data() as Map<String, dynamic>)["name"];
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
            idProduct: id,
            category: category,
            stockProduct: stock,
          );
        }));
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: stock == 0
            ? Stack(
                alignment: Alignment.topCenter,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: image == null
                                ? const Icon(Icons.image_not_supported_outlined)
                                : Image.network(
                                    image ?? '',
                                    fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Text('No Internet',style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 8),),
                                );
                              },
                                  ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 8, bottom: 2),
                        child: Text(
                          name.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
                    height: 100,
                    child: Center(
                      child: Text(
                        'Not available',
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  )
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: image == null
                        ? Row(
                            children: [
                              Expanded(
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          topLeft: Radius.circular(10),
                                        ),
                                        color: Colors.grey.shade300,
                                      ),
                                      height: 100,
                                      child: const Icon(
                                          Icons.image_not_supported_outlined))),
                            ],
                          )
                        : Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                image ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Center(
                                    child: Text('No Internet',style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 8),),
                                  );
                                },
                              ),
                            ),
                          ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 8, bottom: 2),
                    child: Text(
                      name.toString(),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
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
    );
  }
}
