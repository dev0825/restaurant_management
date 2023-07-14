// import 'dart:html';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:premium_hotels/DataBase.dart';

class Addcategory extends StatefulWidget {
  const Addcategory({Key? key}) : super(key: key);

  @override
  State<Addcategory> createState() => _AddcategoryState();
}

class _AddcategoryState extends State<Addcategory> {
  final TextEditingController _categoryName = TextEditingController();
  final TextEditingController _categoryDesciption = TextEditingController();
  File localImagePath = File("");
  String imageUrl = "";
  void newCategory() async {
    try {
      // Sign Up
      await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("Category")
          .doc()
          .set({
        "Name": _categoryName.text,
        "Image": imageUrl,
        "Desciption": _categoryDesciption.text,
      }).then((value) {
        DataStore.isImageSelected = false;
        Navigator.pop(context);
      });
    } catch (e) {
      // print(e);
    }
  }

  void newExpenseCategory() async {
    try {
      // Sign Up
      List category = [];
      List categoryUrl = [];
      DocumentReference<Map<String, dynamic>> ex = FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("PL")
          .doc("Loss");
      DocumentSnapshot<Map<String, dynamic>> exData = await ex.get();
      category = exData["Category"];
      categoryUrl = exData["CategoryUrl"];
      category.add(_categoryName.text);
      categoryUrl.add(imageUrl);
      ex.update({
        "Category": category,
        "CategoryUrl": categoryUrl,
      }).then((value) {
        DataStore.isImageSelected = false;
        DataStore.addExpanseCategory = false;
        Navigator.pop(context);
      });
    } catch (e) {
      // print(e);
    }
  }

  selectImage() async {
    final _picker = ImagePicker();
    XFile? image;
    //Check Permissions
    await Permission.photos.request();
    var permissionStatus = await Permission.photos.status;
    if (permissionStatus.isGranted) {
      //Select Image
      image = await _picker.pickImage(source: ImageSource.gallery);
      // image = await _picker.getImage(source: ImageSource.gallery);
      var file = File(image!.path);
      if (image != null) {
        //Upload to Firebase
        setState(() {
          DataStore.isImageSelected = true;
          localImagePath = file;
          // print("Selcting Image : " + localImagePath.path);
          // print(localImagePath);
        });
      } else {
        // print('No Path Received');
      }
    }
  }

  uploadImage() async {
    dynamic uploadImageUrl;
    final _storage = FirebaseStorage.instance;
    if (localImagePath.path != null) {
      // print("2 Before");
      // print(localImagePath.path);
      if (DataStore.isImageSelected) {
        var snapshot = await _storage
            .ref()
            .child('01/Category/' + _categoryName.text + '.jpg')
            .putFile(localImagePath)
            .whenComplete(() => print("Done"));
        uploadImageUrl = await snapshot.ref.getDownloadURL();
      } else {
        uploadImageUrl =
            "https://firebasestorage.googleapis.com/v0/b/hotel-premium-c357d.appspot.com/o/Profile%2Fmale.jpg?alt=media&token=524af257-73ae-4492-a338-1f1b42865279";
      }
      setState(() {
        imageUrl = uploadImageUrl;
      });
      newCategory();
    } else {
      print('No Path Received');
    }
  }

  uploadImage1() async {
    dynamic uploadImageUrl;
    final _storage = FirebaseStorage.instance;
    if (localImagePath.path != null) {
      // print("2 Before");
      // print(localImagePath.path);
      if (DataStore.isImageSelected) {
        var snapshot = await _storage
            .ref()
            .child('01/ExpenseCategory/' + _categoryName.text + '.jpg')
            .putFile(localImagePath)
            .whenComplete(() => print("Done"));
        uploadImageUrl = await snapshot.ref.getDownloadURL();
      } else {
        uploadImageUrl =
            "https://firebasestorage.googleapis.com/v0/b/hotel-premium-c357d.appspot.com/o/Profile%2Fmale.jpg?alt=media&token=524af257-73ae-4492-a338-1f1b42865279";
      }
      setState(() {
        imageUrl = uploadImageUrl;
      });
      newExpenseCategory();
    } else {
      print('No Path Received');
    }
  }

// ------------------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Add Category'),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //Category Name
            TextField(
              controller: _categoryName,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 214, 83, 83)),
              decoration: InputDecoration(
                hintText: "Category Name",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Color.fromARGB(255, 225, 227, 230),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xfffe9721))),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Color(0xfffe9721))),
              ),
            ),
            // validator: (String? value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter some text';
            //     }
            //     return null;
            //   },

            //Description
            const SizedBox(height: 10),
            (!DataStore.addExpanseCategory)
                ? TextField(
                    controller: _categoryDesciption,
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 214, 83, 83)),
                    decoration: InputDecoration(
                      hintText: "Enter Description",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: Color.fromARGB(255, 225, 227, 230),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xfffe9721))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xfffe9721))),
                    ),
                  )
                : const Text(""),

            //Create Category
            // TextFormField(
            //   decoration: const InputDecoration(
            //     hintText: 'Enter Name',
            //   ),
            //   validator: (String? value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter some text';
            //     }
            //     return null;
            //   },
            // ),

            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: (!DataStore.isImageSelected)
                        ? Image.asset("assets/images/Default_profile.jpg")
                        : Image.file(localImagePath),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                ElevatedButton(
                    onPressed: () {
                      selectImage();
                    },
                    child: const Text("Image")),
              ],
            ),
            const SizedBox(height: 10.0),
            Container(
              margin: const EdgeInsets.all(25),
              child: ElevatedButton(
                onPressed: () {
                  if (DataStore.addExpanseCategory) {
                    uploadImage1();
                  } else {
                    uploadImage();
                  }
                },
                child: const Text('Create Category'),
                style: ElevatedButton.styleFrom(
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
