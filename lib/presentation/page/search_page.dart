import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/widget/grid_catalogue_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController querySearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    querySearch.addListener(() {
      setState(() {});
    });

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Center(child: search()),
        ),
        body: querySearch.text.isNotEmpty
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('products')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    var y = snapshot.data!.docs
                        .where(
                          (QueryDocumentSnapshot<Object?> element) =>
                              element['name']
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(
                                    querySearch.text.toLowerCase(),
                                  ),
                        )
                        .toList();

                    if (y.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/img5.png',
                              width: 200,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Oops! There is no suitable product. Try using different keywords.',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return GridView.builder(
                        padding: const EdgeInsets.all(10),
                        scrollDirection: Axis.vertical,
                        itemCount: y.length,
                        itemBuilder: (context, index) {
                          var z = y[index];
                          return GridCatalogueCard(z.id);
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 4,
                        ),
                      );
                    }
                  } else {
                    return const Text('eror');
                  }
                },
              )
            : Center(
                child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Type in the product name keyword to start searching',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              )),
      ),
    );
  }

  Widget search() {
    return TextField(
      controller: querySearch,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade600),
        ),
        hintStyle: TextStyle(
            color: Colors.grey.shade600,
            fontWeight: FontWeight.bold,
            fontSize: 16),
        //<-- SEE HERE
        hintText: 'Search Products Here',

        prefixIcon: Icon(Icons.search, color: Colors.grey.shade600),
        suffixIcon: querySearch.text.isNotEmpty
            ? IconButton(
                onPressed: () {
                  querySearch.clear();
                },
                icon: const Icon(Icons.cancel, color: Colors.grey),
              )
            : null,
      ),
    );
  }
}
