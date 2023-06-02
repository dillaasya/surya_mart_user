import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/article_page.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';
import 'package:surya_mart_v1/presentation/page/cart_page.dart';
import 'package:surya_mart_v1/presentation/widget/horizontal_list_card.dart';
import 'package:url_launcher/link.dart';
import 'package:badges/badges.dart' as badge;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = Auth();

  String? uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    uid = currentUser.currentUser?.uid;
  }

  Future<bool?> _onBackPressed() async {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              content: Text(
                "Are you sure you want to exit the app?",
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
                    "Yes",
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
                    "No",
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
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          final shouldPop = await _onBackPressed();
          return shouldPop ?? false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xff025ab4),
            elevation: 0,
            flexibleSpace: Padding(
              padding:
                  const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 8),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('uid', isEqualTo: uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.connectionState ==
                      ConnectionState.active) {
                    var x = snapshot.data!.docs.first;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: x
                                        .get('profilePicture')
                                        .toString()
                                        .isEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: const Icon(Icons.person),
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child:
                                            x.data()['profilePicture'] == null
                                                ? const Icon(Icons.person,
                                                    color: Colors.black)
                                                : Image.network(
                                                    x.get('profilePicture'),
                                                    fit: BoxFit.cover,
                                                    width: 100,
                                                  ),
                                      ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  x.get('displayName'),
                                  maxLines: 1,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const CartPage();
                            }));
                          },
                          icon: badge.Badge(
                            badgeContent: Text(
                              x.get('shoppingCart').toString(),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined),
                          ),
                          color: Colors.white,
                        )
                      ],
                    );
                  } else {
                    return const Text('EROR');
                  }
                },
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [product(), article()],
            ),
          ),
        ),
      ),
    );
  }

  Widget product() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('TOP SELLING',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const BottomNavbar(
                                    currentIndex: 1,
                                  )),
                        );
                      },
                      child: Text('SEE ALL',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 215,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .orderBy('sold', descending: true)
                      .limit(10)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Eror : ${snapshot.hasError}");
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          separatorBuilder: (context, _) => const SizedBox(
                            width: 10,
                          ),
                          itemBuilder: (context, index) {
                            var ds = snapshot.data?.docs[index];
                            return ListCard(ds?.id);
                          },
                        );
                    }
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('BEST DEALS',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const BottomNavbar(
                                    currentIndex: 1,
                                  )),
                        );
                      },
                      child: Text('SEE ALL',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 215,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .orderBy('price')
                      .limit(10)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Eror : ${snapshot.hasError}");
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          separatorBuilder: (context, _) => const SizedBox(
                            width: 10,
                          ),
                          itemBuilder: (context, index) {
                            var ds = snapshot.data?.docs[index];
                            log('Index : $ds');
                            return ListCard(ds?.id);
                          },
                        );
                    }
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('NEW PRODUCT',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const BottomNavbar(
                                    currentIndex: 1,
                                  )),
                        );
                      },
                      child: Text('SEE ALL',
                          style:
                              GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 215,
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('products')
                      .orderBy('dateCreated', descending: true)
                      .limit(10)
                      .snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Eror : ${snapshot.hasError}");
                    }
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const Center(child: CircularProgressIndicator());
                      default:
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, _) => const SizedBox(
                            width: 10,
                          ),
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            var ds = snapshot.data?.docs[index];
                            log('Index : $ds');
                            return ListCard(ds?.id);
                          },
                        );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget article() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('ARTICLE',
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
              TextButton(
                child: Text('SEE ALL',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ArticlePage()),
                  );
                },
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('articles')
                .orderBy("dateModified", descending: true)
                .limit(4)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var ds = snapshot.data?.docs[index];
                      return Link(
                        uri: Uri.parse((ds!.data())["link"]),
                        builder: (context, followLink) {
                          return InkWell(
                            onTap: followLink,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${(ds.data())["title"]}',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500)),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text('${(ds.data())["overview"]}',
                                    maxLines: 3,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300)),
                                const Divider(),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    });
              } else {
                return const Text('EROR');
              }
            },
          ),
        ],
      ),
    );
  }
}
