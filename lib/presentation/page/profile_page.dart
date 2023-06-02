import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:surya_mart_v1/presentation/page/about_page.dart';
import 'package:surya_mart_v1/presentation/page/address_page.dart';
import 'package:surya_mart_v1/presentation/page/edit_profile.dart';
import 'package:surya_mart_v1/presentation/page/order_history.dart';
import 'package:surya_mart_v1/presentation/page/review_page.dart';
import 'package:surya_mart_v1/presentation/page/signin_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
          appBar: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                color: const Color(0xff025ab4),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Profile',
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Auth().signOut().whenComplete(() {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => const SigninPage(),
                              ),
                            );
                          });
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          //backgroundColor: const Color(0xff025ab4),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: Auth().currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.active) {
                var x = snapshot.data!.docs.first;
                return ListView(
                  children: [
                    Container(
                        color: const Color(0xff025ab4),
                        child: profilePicture(x)),
                    profileMenu(x),
                  ],
                );
              } else {
                return const Text('Eror');
              }
            },
          ),
        ),
      ),
    );
  }

  Widget profilePicture(QueryDocumentSnapshot user) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: user.get('profilePicture').toString().isNotEmpty
                  ? Image.network(
                      user.get('profilePicture').toString(),
                      fit: BoxFit.cover,
                      width: 100,
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Text('No Internet',style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w300,
                        fontSize: 8),),
                  );
                },
                    )
                  : const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.black,
                    ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          SizedBox(
            width: 150,
            child: Text(
              user.get('displayName'),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.visible,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontWeight: FontWeight.w300),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            '${user['poin'].toString()} points',
            style: GoogleFonts.poppins(
                color: Colors.white, fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }

  Widget profileMenu(QueryDocumentSnapshot user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.people_outline),
            title: Text(
              'Edit Profile',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfile()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined),
            title: Text(
              'Shipping Address',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => AddressPage(
                          id: user.id,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.access_time),
            title: Text(
              'Order History',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => OrderHistory(
                          id: user.id,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.reorder_outlined),
            title: Text(
              'My Reviews',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const ReviewPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.chat_bubble_outline),
            title: Text(
              'Contact The Store',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              launchUrl(Uri.parse(
                  'whatsapp://send/?phone=+6285231803644&text=Hi, can you help me?'));
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(
              'About',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w300,
                color: Colors.black,
              ),
            ),
            trailing: const Icon(Icons.navigate_next_rounded),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const AboutPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
