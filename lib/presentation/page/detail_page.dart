import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/add_to_cart.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';
import 'package:surya_mart_v1/presentation/page/cart_page.dart';
import 'package:surya_mart_v1/presentation/widget/horizontal_list_card.dart';

class DetailPage extends StatefulWidget {
  final String? idProduct;
  final String? category;
  final int? stockProduct;

  const DetailPage(
      {required this.idProduct,
      required this.stockProduct,
      required this.category,
      Key? key})
      : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int qty = 1;

  int stock = 0;
  int price = 0;
  int weight = 0;
  int shoppingCart = 0;
  String? name, description, image, idProduct;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getShoppingCartUser();
  }

  @override
  Widget build(BuildContext context) {
    //print('nilai id produk di halaman detail = ${widget.idProduct}');
    void customBottomSheet(
        String? id, String? name, String? image, int price, int weight) {
      showModalBottomSheet(
          isScrollControlled: true,
          //isDismissible: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          context: context,
          builder: (builder) {
            return AddToCart(
              id: widget.idProduct!,
              name: name!,
              image: image,
              price: price,
              weight: weight,
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Container(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.black.withOpacity(0.3),
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const CartPage();
                        }));
                      },
                      icon: Badge(
                        badgeContent: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('uid', isEqualTo: Auth().currentUser!.uid)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (snapshot.connectionState ==
                                ConnectionState.active) {
                              var x = snapshot.data!.docs.first;
                              return Text(x['shoppingCart'].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ));
                            } else {
                              return const Text('eror');
                            }
                          },
                        ),
                        child: const Icon(Icons.shopping_cart_outlined),
                      ),
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .doc(widget.idProduct)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                var x = snapshot.data!.data();

                name = x?['name'];
                image = x?['image'];
                price = x?['price'];
                weight = x?['weight'];
                stock = x?['stock'];

                return SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.width,
                            color: Colors.white,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.width,
                              child: x?['image'] == null
                                  ? Icon(
                                      Icons.image_not_supported_outlined,
                                      size: MediaQuery.of(context).size.width *
                                          0.3,
                                    )
                                  : ClipRRect(
                                      child: Image.network(x?['image'] ?? '',
                                          fit: BoxFit.fill),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Container(
                          color: Colors.white,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${x?['name']}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  'Rp ${x?['price']}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.redAccent,
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
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Delivery',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                    )),
                                const SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    const Icon(Icons.local_shipping_outlined),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      'Free Shipping',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                  ],
                                )
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Description',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ExpandableText(
                                  x?['description'],
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                  ),
                                  expandText: 'show more',
                                  collapseText: 'show less',
                                  maxLines: 5,
                                  linkColor: Colors.blue,
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
                          child: productSection('You may also like'),
                        ),
                      ]),
                );
              } else {
                return const Text('Product doesnt exist');
              }
            } else {
              return const Text('eror');
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
          child: SizedBox(
            height: 70,
            child: widget.stockProduct == 0
                ? Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.orangeAccent.withOpacity(0.7),
                      ),
                      child: Center(
                        child: Text(
                          'Not Available',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.orangeAccent),
                      child: TextButton(
                        onPressed: () {
                          customBottomSheet(
                              widget.idProduct, name, image, price, weight);
                        },
                        child: Text(
                          'Add to cart',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget productSection(String subHeader) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                subHeader,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const BottomNavbar(
                              currentIndex: 1,
                            )),
                  );
                },
                child: const Text(
                  'SEE ALL',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        SizedBox(
          height: 215,
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('products')
                .where('category', isEqualTo: widget.category)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                return ListView.separated(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  separatorBuilder: (context, _) => const SizedBox(
                    width: 4,
                  ),
                  itemBuilder: (context, index) {
                    var x = snapshot.data!.docs[index];

                    return ListCard(x.id);
                  },
                );
              } else {
                return const Text('eror');
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
