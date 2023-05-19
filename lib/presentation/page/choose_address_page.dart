import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/presentation/page/checkout_page.dart';

class ChooseAddress extends StatefulWidget {
  final String idUser;

  const ChooseAddress({required this.idUser, Key? key}) : super(key: key);

  @override
  State<ChooseAddress> createState() => _ChooseAddressState();
}

class _ChooseAddressState extends State<ChooseAddress> {
  int indexRadio = 0;

  Future<void> getGroupValue() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('address')
        .get()
        .then((value) {
      var y = value.docs;
      int indexList = 0;

      while (indexList < y.length) {
        if (y[indexList].get('isSelected') == true) {
          setState(() {
            indexRadio = indexList;
          });
        }
        indexList++;
      }
    });
  }

  Future<void> updateMainAddress(String id) async {
    //print('panggil delete satu item address');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('address')
        .doc(id)
        .update({'isSelected': false});
  }

  Future<void> updateAllAddress() async {
    //print('panggil delete all address');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('address')
        .where('isSelected', isEqualTo: true)
        .get()
        .then((value) {
      for (var element in value.docs) {
        updateMainAddress(element.id);
      }
    });

    //print('selesai delete all address');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupValue();
    //print('group value $indexRadio');
  }

  @override
  Widget build(BuildContext context) {
    //print('group value $indexRadio');
    //getGroupValue();
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            title: Text(
                'Choose Address',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500, color: Colors.black, fontSize:16)
            ),
          ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(widget.idUser)
            .collection('address')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.active) {
            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var x = snapshot.data!.docs[index];

                /*print(
                    'indeks $index kode pos ${x.data()['codeNumber'].toString()}');*/
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: RadioListTile(
                      isThreeLine:true,
                      //dense:true,
                      activeColor: const Color(0xffFFC33A),
                      value: index,
                      groupValue: indexRadio,
                      onChanged: (newVal) {
                        setState(() {
                          updateAllAddress().whenComplete(() {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(widget.idUser)
                                .collection('address')
                                .doc(x.id)
                                .update({'isSelected': true});
                          });
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    CheckoutPage(idUser: widget.idUser),
                              ));
                        });
                      },
                      title: Text(x.data()['recipientName'],style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: Colors.black),),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(x.data()['phone'].toString(),style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w300,
                              color: Colors.black54),),
                          Text('${x.data()['fullAddress']}, ${x.data()['codeNumber']}',style:
                          GoogleFonts.poppins(color: Colors.black54),),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Text('eror');
          }
        },
      ),
    ));
  }
}
