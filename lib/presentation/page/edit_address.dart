import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditAddress extends StatefulWidget {
  final String idAddress;
  final String idUser;

  const EditAddress({required this.idAddress, required this.idUser, Key? key})
      : super(key: key);

  @override
  State<EditAddress> createState() => _EditAddressState();
}

class _EditAddressState extends State<EditAddress> {
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  bool isLoading = false;

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  TextEditingController recipientNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController codeNumberController = TextEditingController();
  TextEditingController fullAddressController = TextEditingController();
  TextEditingController detailAddressController = TextEditingController();

  setValue() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('address')
        .doc(widget.idAddress)
        .get()
        .then((value) {
      recipientNameController.text = value.data()?['recipientName'];
      phoneController.text = value.data()?['phone'].toString() ?? '';
      provinceController.text = value.data()?['province'];
      cityController.text = value.data()?['city'];
      codeNumberController.text = value.data()?['codeNumber'].toString() ?? '';
      fullAddressController.text = value.data()?['fullAddress'];
      detailAddressController.text = value.data()?['detailAddress'];
    });
  }

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

  saveEdit() {
    setState(() {
      isLoading = true;
    });

    String newRecipientName = recipientNameController.text;
    String newPhone = phoneController.text;
    String newProvince = provinceController.text;
    String newCity = cityController.text;
    String newCodeNumber = codeNumberController.text;
    String newFullAddress = fullAddressController.text;
    String newDetailAddress = detailAddressController.text;

    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.idUser)
        .collection('address')
        .doc(widget.idAddress)
        .update({
      'city': newCity,
      'codeNumber': newCodeNumber,
      'detailAddress': newDetailAddress,
      'fullAddress': newFullAddress,
      'phone': newPhone,
      'province': newProvince,
      'recipientName': newRecipientName,
    });

    setState(() {
      isLoading = false;
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    setValue();
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
            title: Text('Edit Address',
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
                                    saveEdit();
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
