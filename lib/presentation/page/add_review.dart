import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';

class AddReview extends StatefulWidget {
  final String idOrder;
  final String idUser;
  final List<dynamic> listCart;

  const AddReview(
      {required this.idOrder,
      required this.idUser,
      required this.listCart,
      Key? key})
      : super(key: key);

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController reviewController = TextEditingController();

  bool isLoading = false;

  _submitReview() {
    setState(() {
      isLoading = true;
    });

    firestore.collection('reviews').add({
      "rate": rating,
      "review": reviewController.text,
      'idOrder': widget.idOrder,
      'idUser': widget.idUser,
      'uid': Auth().currentUser!.uid,
      'dateCreated': FieldValue.serverTimestamp(),
    }).whenComplete(() {
      FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.idOrder)
          .update({'isReviewed': true});
    });

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
    setState(() {});
  }

  double rating = 0;

  @override
  void initState() {
    super.initState();
    for (var element in widget.listCart) {
      nama.add(element['productName']);
    }
  }

  List<String> nama = [];

  Future<bool?> _onBackPressed() async {
    return showDialog<bool>(
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
                "Are you sure you want to come back? Existing data will not be saved",
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
    return isLoading
        ? const SafeArea(
            child: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                if (isLoading) {
                  return false;
                } else {
                  final shouldPop = await _onBackPressed();
                  return shouldPop ?? false;
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.black),
                  elevation: 0,
                  title: Text(
                    'Leave a Review',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontSize: 16),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: _formKeyValue,
                    autovalidateMode: AutovalidateMode.always,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nama.join(','),
                                      style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Whats your rate?',
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w300,
                                              color: Colors.black),
                                        ),
                                        RatingBar.builder(
                                          itemSize: 25,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          updateOnDrag: true,
                                          itemCount: 5,
                                          itemPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 2.0),
                                          itemBuilder: (context, _) =>
                                              const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            setState(() {
                                              this.rating = rating;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ]),
                            )),
                        const SizedBox(height: 8),
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'What can we improve?',
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.black),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: TextFormField(
                                    maxLines: 5,
                                    validator: (value) {
                                      if (value!.isNotEmpty &&
                                          value.length > 2) {
                                        return null;
                                      } else if (value.length < 5 &&
                                          value.isNotEmpty) {
                                        return 'Your review is too short!';
                                      } else {
                                        return 'It can\'t be empty!';
                                      }
                                    },
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w300,
                                        color: Colors.black),
                                    controller: reviewController,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        borderSide: const BorderSide(
                                          color: Colors.deepOrangeAccent,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1.0,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                          width: 1.0,
                                        ),
                                      ),
                                      contentPadding: const EdgeInsets.only(
                                          left: 24,
                                          top: 18,
                                          bottom: 18,
                                          right: 24),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: BottomAppBar(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.only(top: 18, bottom: 18)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0XFFFFC33A)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                              side: const BorderSide(
                                color: Color(0XFFFFC33A),
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Save',
                          style: GoogleFonts.poppins(
                              color: Colors.grey.shade800,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          if (_formKeyValue.currentState!.validate()) {
                            _submitReview();
                          }
                        }),
                  ),
                ),
              ),
            ),
          );
  }
}
