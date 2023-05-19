import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/search_page.dart';
import 'package:surya_mart_v1/presentation/widget/grid_catalogue_card.dart';

class CataloguePage extends StatefulWidget {
  const CataloguePage({Key? key}) : super(key: key);

  @override
  State<CataloguePage> createState() => _CataloguePageState();
}

class _CataloguePageState extends State<CataloguePage> {
  var listHeaderTab = ['All Product', 'Top Selling', 'Best Deals'];
  var listCategoryName = [];

  getListCategory() {
    FirebaseFirestore.instance
        .collection('categories')
        .snapshots()
        .forEach((element) {
      for (var element in element.docs) {
        setState(() {
          listHeaderTab.add(element.data()['name']);
          listCategoryName.add(element.data()['name']);
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getListCategory();
  }

  Future<bool?> _onBackPressed() async {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          actionsAlignment: MainAxisAlignment.center,
          content: Text(
            "Apakah anda yakin ingin keluar dari aplikasi?",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                "Ya",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                "Tidak",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w300,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    var viewTabDefault = <Widget>[
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('stock', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var y = snapshot.data!.docs[index];

                return GridCatalogueCard(y.id);
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
              ),
            );
          } else {
            return const Text('eror');
          }
        },
      ),
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('sold', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var y = snapshot.data!.docs[index];

                return GridCatalogueCard(y.id);
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
              ),
            );
          } else {
            return const Text('eror');
          }
        },
      ),
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .orderBy('price')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var y = snapshot.data!.docs[index];

                return GridCatalogueCard(y.id);
              },
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 8,
                crossAxisSpacing: 4,
              ),
            );
          } else {
            return const Text('eror');
          }
        },
      ),
    ];

    var viewTabCategory = listCategoryName.map<Widget>((e) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: e)
            .orderBy('stock', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data != null) {
              return GridView.builder(
                padding: const EdgeInsets.all(10),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data?.docs.length,
                itemBuilder: (context, index) {
                  var y = snapshot.data?.docs[index];

                  return GridCatalogueCard(y?.id);
                },
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                ),
              );
            } else {
              return Center(
                child: Text('Tidak ada produk tersedia',style:
                GoogleFonts.poppins(fontWeight: FontWeight.w400),),
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
      child: WillPopScope(
        onWillPop: () async {
          final shouldPop = await _onBackPressed();
          return shouldPop ?? false;
        },
        child: DefaultTabController(
          length: listHeaderTab.length,
          child: Scaffold(
            appBar:
            PreferredSize(
                preferredSize: const Size.fromHeight(128),
                child: Container(
                  color: const Color(0xff025ab4),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left:16, right:16, top:16, bottom:3),
                        child: search(),
                      ),
                      TabBar(
                        labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 14,
                        ),
                        isScrollable: true,
                        tabs: listHeaderTab
                            .map((e) => Tab(
                                  text: e,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                )),
            body: TabBarView(
                children: listHeaderTab.length < 4 ? viewTabDefault : viewTabAll),
          ),
        ),
      ),
    );
  }

  Widget search() {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SearchPage()),
        );
      },
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
            disabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(10),
            ),
            filled: true,
            fillColor: const Color(0x33ffffff),
            hintStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w300,
              color: Colors.white,
              fontSize: 14,
            ),
            hintText: 'Type name here...',
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.white,
            )),
      ),
    );
  }
}
