import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:surya_mart_v1/data/service/auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:surya_mart_v1/presentation/page/bottom_navbar.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController displayNameController = TextEditingController();
  String? email, id, newImage;
  String image = '';
  int? poin = 0;

  File? _imagePath;
  String? _urlItemImage;

  bool isLoading = false;

  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  void setValue() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: Auth().currentUser!.uid)
        .get()
        .then((value) => value.docs.first)
        .then((value) {
      setState(() {
        id = value.id;
        email = Auth().currentUser!.email;
        phoneController.text = value.data()['phone'];
        displayNameController.text = value.data()['displayName'];
        image = value.data()['profilePicture'].toString();
        poin = value.data()['poin'];
      });
    });
  }

  getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = File(image.path);
        //_imageTemporary = File(_image.path).toString();
      });
    }
  }

  Widget gambarSebelumnyaAda() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        //color: Colors.yellow,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              right: MediaQuery.of(context).size.width / 2 - 40,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: image == null
                      ? const CircularProgressIndicator()
                      : Image.network(
                          image.toString(),
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 40,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: _imagePath != null
                      ? Image.file(
                          _imagePath!,
                          fit: BoxFit.cover,
                          width: 100,
                        )
                      : const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.black,
                        ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2 + 30,
              child: _imagePath == null
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[200],
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await getImageFromGallery();

                          setState(() {});
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[200],
                      ),
                      child: IconButton(
                        onPressed: () {
                          _imagePath = null;

                          setState(() {});
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gambarSebelumnyaKosong() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        //color: Colors.yellow,
        height: 100,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: _imagePath != null
                      ? Image.file(
                          _imagePath!,
                          fit: BoxFit.cover,
                          width: 100,
                        )
                      : const Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.black,
                        ),
                ),
              ),
            ),
            Positioned(
              top: 50,
              left: MediaQuery.of(context).size.width / 2,
              child: _imagePath == null
                  ? Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[200],
                      ),
                      child: IconButton(
                        onPressed: () async {
                          await getImageFromGallery();

                          setState(() {});
                        },
                        icon: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  : Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.grey[200],
                      ),
                      child: IconButton(
                        onPressed: () {
                          _imagePath = null;

                          setState(() {});
                        },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  saveEdit() async {
    setState(() {
      isLoading = true;
    });

    String newDisplayName = displayNameController.text;
    String newPhone = phoneController.text.toString();

    if (image.isNotEmpty) {
      if (_imagePath != null) {
        Reference reference = storage.refFromURL(image);

        //print('nilai reference: $reference');

        var updateImage = reference.putFile(_imagePath!);
        //uploadTask.snapshotEvents.listen((event) {});

        await updateImage.whenComplete(() async {
          _urlItemImage = await updateImage.snapshot.ref.getDownloadURL();

          if (_urlItemImage!.isNotEmpty) {
            //print("URL : $_urlItemImage");

            CollectionReference users = firestore.collection('users');

            users.doc(id).update({
              'displayName': newDisplayName,
              'phone': newPhone,
              'dateModified': FieldValue.serverTimestamp(),
              'profilePicture': _urlItemImage,
            });
          } else {
            //_showMessage("Something When Wrong While Uploading Image");
          }
        });
      } else {
        CollectionReference users = firestore.collection('users');

        users.doc(id).update({
          'displayName': newDisplayName,
          'phone': newPhone,
          'dateModified': FieldValue.serverTimestamp(),
          //'profilePicture': _urlItemImage,
        });
      }
      //String fileName = DateTime.now().millisecondsSinceEpoch.toString();

    } else {
      if (_imagePath != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference = storage.ref().child('users/$fileName');
        UploadTask uploadTask = reference.putFile(_imagePath!);

        await uploadTask.whenComplete(() async {
          _urlItemImage = await uploadTask.snapshot.ref.getDownloadURL();

          if (_urlItemImage!.isNotEmpty) {
            CollectionReference users = firestore.collection('users');
            users.doc(id).update({
              'displayName': newDisplayName,
              'phone': newPhone,
              'dateModified': FieldValue.serverTimestamp(),
              'profilePicture': _urlItemImage,
            });
          } else {}
        });
      } else {
        CollectionReference users = firestore.collection('users');

        users.doc(id).update({
          'displayName': newDisplayName,
          'phone': newPhone,
          'dateModified': FieldValue.serverTimestamp()
        });
      }
    }

    setState(() {
      isLoading = false;
    });

    if (mounted) {
      Navigator.pop(context);
    }
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
        onWillPop: () async {
          if (isLoading) {
            return false;
          } else {
            final shouldPop = await _onBackPressed();
            return shouldPop ?? false;
          }
        },
        child: isLoading
            ? const SafeArea(
                child: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              )
            : Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  iconTheme: const IconThemeData(color: Colors.black),
                  elevation: 0,
                  title: Text('Edit Profile',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16)),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKeyValue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          image.isEmpty
                              ? gambarSebelumnyaKosong()
                              : gambarSebelumnyaAda(),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(
                                'Number of points : ${poin.toString()}',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w300,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Email',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 20, right: 20, top: 8),
                            child: TextFormField(
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: email,
                                enabled: false,
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade400,
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Full name',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 20, right: 20, top: 8),
                            child: TextFormField(
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              validator: (value) {
                                if (value!.isNotEmpty && value.length > 2) {
                                  return null;
                                } else if (value.length < 5 &&
                                    value.isNotEmpty) {
                                  return 'Your name is too short!';
                                } else {
                                  return 'It can\'t be empty!';
                                }
                              },
                              controller: displayNameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: const BorderSide(
                                    color: Colors.deepOrangeAccent,
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
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              'Phone number',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 20, left: 20, right: 20, top: 8),
                            child: TextFormField(
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                color: Colors.black,
                              ),
                              keyboardType: TextInputType.phone,
                              controller: phoneController,
                              validator: (value) {
                                if (value!.isNotEmpty && value.length > 2) {
                                  return null;
                                } else if (value.length < 5 &&
                                    value.isNotEmpty) {
                                  return 'Please enter a valid phone number';
                                } else {
                                  return 'It can\'t be empty!';
                                }
                              },
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: const BorderSide(
                                    color: Colors.deepOrangeAccent,
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
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
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
                                        saveEdit().whenComplete(() {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    const BottomNavbar(
                                                      currentIndex: 2,
                                                    )),
                                          );
                                        });
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
      ),
    );
  }
}
