import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/add_new_address.dart';
import 'package:surya_mart_v1/presentation/page/edit_address.dart';

class AddressPage extends StatefulWidget {
  final String id;

  const AddressPage({required this.id, Key? key}) : super(key: key);

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> updateMainAddress(String id) async {
    //print('panggil delete satu item address');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection('address')
        .doc(id)
        .update({'isPrimary': false, 'isSelected': false});
  }

  Future<void> updateAllAddress() async {
    //print('panggil delete all address');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.id)
        .collection('address')
        .where('isPrimary', isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        updateMainAddress(element.id);
      }
    });

    //print('selesai delete all address');
  }

  showDialogToggle(String selectedId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          "Warning!",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "Are you sure you want to change this address as the primary address?",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              updateAllAddress().whenComplete(() {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.id)
                    .collection('address')
                    .doc(selectedId)
                    .update({'isPrimary': true, 'isSelected': true});
              });
              Navigator.pop(context);
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          elevation: 0,
          title: Text('Shipping Address',
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                  fontSize: 16)),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.id)
              .collection('address')
              .orderBy('isPrimary', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    var x = snapshot.data!.docs[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              x.data()['recipientName'],
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              (x.data()['phone']).toString(),
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black54),
                            ),
                            Text(
                              x.data()['fullAddress'] +
                                  ', ' +
                                  (x.data()['codeNumber']).toString(),
                              style: GoogleFonts.poppins(color: Colors.black54),
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        //textStyle: const TextStyle(fontSize: 20),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => EditAddress(
                                              idAddress: x.id,
                                              idUser: widget.id,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Text('Edit',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          )),
                                    ),
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor:
                                            x.data()['isPrimary'] == true
                                                ? Colors.black.withOpacity(0.4)
                                                : Colors.black,
                                      ),
                                      onPressed: () {
                                        if (x.data()['isPrimary'] == true) {
                                          null;
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                actionsAlignment:
                                                    MainAxisAlignment.center,
                                                title: Text(
                                                  "Warning!",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                content: Text(
                                                  "Are you sure you want to delete this address?",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w300,
                                                    color: Colors.black,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      FirebaseFirestore.instance
                                                          .collection('users')
                                                          .doc(widget.id)
                                                          .collection('address')
                                                          .doc(x.id)
                                                          .delete();
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      "Yes",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop(false);
                                                    },
                                                    child: Text(
                                                      "No",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      },
                                      child: Text(
                                        'Delete',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Switch(
                                  value: x.data()['isPrimary'],
                                  activeColor: const Color(0xffFFC33A),
                                  onChanged: (bool value) {
                                    if ((x.data()['isPrimary']) == true) {
                                      null;
                                    } else {
                                      showDialogToggle(x.id);
                                    }
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      'You haven\'t added address yet! Click the icon in the bottom-right corner to add a new address',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            } else {
              return const Text('eror');
            }
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xffFFC33A),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => AddNewAddress(id: widget.id)),
            );
          },
          child: const Icon(
            Icons.add,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
