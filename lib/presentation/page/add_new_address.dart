import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddNewAddress extends StatefulWidget {
  final String id;

  const AddNewAddress({required this.id, Key? key}) : super(key: key);

  @override
  State<AddNewAddress> createState() => _AddNewAddressState();
}

class _AddNewAddressState extends State<AddNewAddress> {
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  bool isLoading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final TextEditingController recipientNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController codeNumberController = TextEditingController();
  final TextEditingController fullAddressController = TextEditingController();
  final TextEditingController detailAddressController = TextEditingController();

  bool check = false;

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

  Future<bool> addressCek(String idUser) {
    Future<bool> x = FirebaseFirestore.instance
        .collection('users')
        .doc(idUser)
        .collection('address')
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    });

    return x;
  }

  addAddress() {
    setState(() {
      isLoading = true;
    });

    addressCek(widget.id).then((value) {
      if (value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.id)
            .collection('address')
            .add({
          'city': cityController.text,
          'codeNumber': codeNumberController.text,
          'detailAddress': detailAddressController.text,
          'fullAddress': fullAddressController.text,
          'phone': phoneController.text,
          'province': provinceController.text,
          'recipientName': recipientNameController.text,
          'isPrimary': false,
          'isSelected': false,
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .doc(widget.id)
            .collection('address')
            .add({
          'city': cityController.text,
          'codeNumber': codeNumberController.text,
          'detailAddress': detailAddressController.text,
          'fullAddress': fullAddressController.text,
          'phone': phoneController.text,
          'province': provinceController.text,
          'recipientName': recipientNameController.text,
          'isPrimary': true,
          'isSelected': true,
        });
      }
    });

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            title: Text('Add New Address',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontSize: 16)),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKeyValue,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Full name',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 8),
                      child: TextFormField(
                        controller: recipientNameController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isNotEmpty && value.length > 2) {
                            return null;
                          } else if (value.length < 5 && value.isNotEmpty) {
                            return 'Your name is too short!';
                          } else {
                            return 'It can\'t be empty!';
                          }
                        },
                      ),
                    ),
                    Text(
                      'Phone number',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        validator: (value) {
                          if (value!.isNotEmpty && value.length > 2) {
                            return null;
                          } else if (value.length < 5 && value.isNotEmpty) {
                            return 'Please enter a valid phone number';
                          } else {
                            return 'It can\'t be empty!';
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Province',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 8),
                      child: TextFormField(
                        controller: provinceController,
                        validator: (value) {
                          if (value!.isNotEmpty && value.length > 2) {
                            return null;
                          } else if (value.length < 5 && value.isNotEmpty) {
                            return 'Please enter a valid province name';
                          } else {
                            return 'It can\'t be empty!';
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'City',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 8),
                      child: TextFormField(
                        controller: cityController,
                        validator: (value) {
                          if (value!.isNotEmpty && value.length > 2) {
                            return null;
                          } else if (value.length < 5 && value.isNotEmpty) {
                            return 'Please enter a valid city name';
                          } else {
                            return 'It can\'t be empty!';
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Full address',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 8),
                      child: TextFormField(
                        maxLines: 4,
                        controller: fullAddressController,
                        validator: (value) {
                          if (value!.isNotEmpty && value.length > 2) {
                            return null;
                          } else if (value.length < 5 && value.isNotEmpty) {
                            return 'Please enter a valid full address';
                          } else {
                            return 'It can\'t be empty!';
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Postal code',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: codeNumberController,
                        validator: (value) {
                          if (value!.isNotEmpty && value.length > 2) {
                            return null;
                          } else if (value.length < 5 && value.isNotEmpty) {
                            return 'Please enter a valid postal code';
                          } else {
                            return 'It can\'t be empty!';
                          }
                        },
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'More details (optional)',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20, top: 8),
                      child: TextFormField(
                        controller: detailAddressController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            borderSide: const BorderSide(
                              color: Colors.black,
                              width: 1.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                                style: ButtonStyle(
                                    padding: MaterialStateProperty.all(
                                        const EdgeInsets.only(
                                            top: 18, bottom: 18)),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0XFFFFC33A)),
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            side: const BorderSide(
                                                color: Color(0XFFFFC33A))))),
                                child: Text(
                                  'Save',
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey.shade800,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  if (_formKeyValue.currentState!.validate()) {
                                    addAddress();
                                  }
                                }),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        onWillPop: () async {
          if (isLoading) {
            return false;
          } else {
            final shouldPop = await _onBackPressed();
            return shouldPop ?? false;
          }
        },
      ),
    );
  }
}
