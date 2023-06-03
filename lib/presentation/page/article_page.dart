import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              iconTheme: const IconThemeData(color: Colors.black),
              elevation: 0,
              title: Text('Articles',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500, color: Colors.black)),
            ),
            body: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('articles').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.active) {
                  if (snapshot.data!.docs.isNotEmpty) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var x = snapshot.data!.docs[index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Link(
                                uri: Uri.parse((x.data())["link"]),
                                builder: (context, followLink) {
                                  return InkWell(
                                    onTap: followLink,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${(x.data())["title"]}',
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500),
                                            maxLines: 2,
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text('${(x.data())["overview"]}',
                                              maxLines: 3,
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w300)),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Divider()
                          ],
                        );
                      },
                    );
                  } else {
                    return const Center(
                        child: Text('No articles can be loaded'));
                  }
                } else {
                  return const Center(
                    child: Text('Eror'),
                  );
                }
              },
            )));
  }
}
