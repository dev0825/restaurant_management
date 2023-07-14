import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:premium_hotels/DataBase.dart';

class Additem extends StatefulWidget {
  const Additem({Key? key}) : super(key: key);

  @override
  State<Additem> createState() => _AdditemState();
}

class _AdditemState extends State<Additem> {
  // List categoryData = DataStore.category;
  // List<int> selectionOfCategory = [];
  List selectedCategory = [];
  File localImagePath = File("");
  String imageUrl = "";

  final TextEditingController _itemName = TextEditingController();
  final TextEditingController _itemDesciption = TextEditingController();
  final TextEditingController _itemQuantity = TextEditingController();
  final TextEditingController _itemPurchasePrice = TextEditingController();
  final TextEditingController _itemDiscountPrice = TextEditingController();
  final TextEditingController _itemWeight = TextEditingController();
  final TextEditingController _itemCode = TextEditingController();

  @override
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

  afterPressedSelectedCatagory() {
    for (var i = 0; i < DataStore.selectionOfCategory.length; i++) {
      if (DataStore.selectionOfCategory[i] == 1) {
        selectedCategory.add(DataStore.category[i]["Name"]);
      }
    }
    uploadImage();
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
            .child('01/Item/' + _itemName.text + '.jpg')
            .putFile(localImagePath)
            .whenComplete(() => print("Done"));
        uploadImageUrl = await snapshot.ref.getDownloadURL();
      } else {
        uploadImageUrl =
            "https://firebasestorage.googleapis.com/v0/b/hotel-premium-c357d.appspot.com/o/Profile%2Fmale.jpg?alt=media&token=524af257-73ae-4492-a338-1f1b42865279";
      }
      setState(
        () {
          imageUrl = uploadImageUrl;
        },
      );
      newItem();
    } else {
      // print('No Path Received');
    }
  }

  void newItem() async {
    try {
      // Sign Up
      await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("Item")
          .doc(_itemName.text)
          .set(
        {
          "Name": _itemName.text,
          "Image": imageUrl,
          "Desciption": _itemDesciption.text,
          "Category": selectedCategory,
          "Quantity": _itemQuantity.text,
          "Purchase Price": _itemPurchasePrice.text,
          "Discount Price": _itemDiscountPrice.text,
          "Weight": _itemWeight.text,
          "Item Code": _itemCode.text,
          "caseSearch": setSearchParam(_itemName.text, _itemCode.text),
        },
      ).then(
        (value) {
          DataStore.isImageSelected = false;
          Navigator.pop(context);
          DataStore.selectionOfCategory = [];
        },
      );
    } catch (e) {
      // print(e);
    }
  }

  setSearchParam(String itemName, String itemCode) {
    itemName = itemName.toLowerCase();
    itemCode = itemCode.toLowerCase();
    List<String> caseSearchList = [];
    String temp = "";
    var arr = itemName.split(' ');

    //This For Whole Word
    for (var i = 0; i < itemName.length; i++) {
      temp = temp + itemName[i];
      caseSearchList.add(temp);
    }

    //This For Broken Word
    temp = "";
    for (var k = 1; k < arr.length; k++) {
      for (int i = 0; i < arr[k].length; i++) {
        temp = temp + arr[k][i];
        caseSearchList.add(temp);
      }
      temp = "";
    }

    //This For Whole Code
    temp = "";
    for (var i = 0; i < itemCode.length; i++) {
      temp = temp + itemCode[i];
      caseSearchList.add(temp);
    }
    temp = "";

    //This For Catagory
    temp = "";
    for (var k = 0; k < selectedCategory.length; k++) {
      for (int i = 0; i < selectedCategory[k].length; i++) {
        temp = temp + selectedCategory[k][i];
        caseSearchList.add(temp.toLowerCase());
      }
      temp = "";
    }
    return caseSearchList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Add Item'),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //Item Name
            TextField(
              controller: _itemName,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 214, 83, 83)),
              decoration: InputDecoration(
                hintText: "Enter Item Name",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 227, 230),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
              ),
            ),
            // validator: (String? value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter Item Name';
            //     }
            //     return null;
            //   },
            const SizedBox(height: 10),
            //Descrition
            TextField(
              controller: _itemDesciption,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 214, 83, 83)),
              decoration: InputDecoration(
                hintText: "Enter Item Description",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 227, 230),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
              ),
            ),
            // validator: (String? value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter some Description';
            //     }
            //     return null;
            //   },
            const SizedBox(height: 10),
            //Item Code
            TextField(
              controller: _itemCode,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 214, 83, 83)),
              decoration: InputDecoration(
                hintText: "Enter Item Code",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 227, 230),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
              ),
            ),
            // validator: (String? value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter some Description';
            //     }
            //     return null;
            //   },

            //Quantity
            TextField(
              controller: _itemQuantity,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 214, 83, 83)),
              decoration: InputDecoration(
                hintText: "Enter Item Quantity",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 227, 230),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
              ),
            ),

            // validator: (String? value) {
            //   if (value == null || value.isEmpty) {
            //     return 'Please enter Quantity';
            //   }
            //   return null;
            // },

            //Purchase Price
            TextField(
              controller: _itemPurchasePrice,
              style: const TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 214, 83, 83)),
              decoration: InputDecoration(
                hintText: "Enter Purchase Price",
                hintStyle: TextStyle(color: Colors.grey.shade700),
                filled: true,
                fillColor: Color.fromARGB(255, 255, 227, 230),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Color(0xfffe9721),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _itemPurchasePrice,
              decoration: const InputDecoration(
                hintText: 'Enter Purchase Price',
              ),
              //for Only Input Of Number
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered

              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Purchase Price';
                }
                return null;
              },
            ),
            //Discount Price
            TextFormField(
              controller: _itemDiscountPrice,
              decoration: const InputDecoration(
                hintText: 'Enter Discount Price',
              ),
              //for Only Input Of Number
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],

              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Discount Price';
                }
                return null;
              },
            ),
            //Photo
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
            //Category
            SizedBox(
              height: 90,
              child: FutureBuilder(
                future: DataStore.fetchListCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    print("Data Error");
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    print("Data Done");
                  }
                  if (DataStore.category.length == 0) {
                    return const Center(child: Text("Opp No Data Is There"));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: DataStore.category.length,
                      itemBuilder: (context, index) {
                        print("Sizes : ");
                        print(DataStore.category[index]["Name"]);
                        return radioButto(
                            DataStore.category[index]["Name"], index);
                      },
                    );
                  }
                },
              ),
            ),
            //Weight
            TextFormField(
              controller: _itemWeight,
              decoration: const InputDecoration(
                hintText: 'Enter Weight',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Weight';
                }
                return null;
              },
            ),
            Container(
              padding: const EdgeInsets.all(50),
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(
                  Icons.add_circle_outline_sharp,
                ),
                iconSize: 50,
                color: Colors.cyan,
                splashColor: Colors.purple[150],
                onPressed: () {
                  afterPressedSelectedCatagory();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget radioButto(String label, int index) {
    print("In : ");
    print(label);
    print(index);
    return Row(
      children: [
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (DataStore.selectionOfCategory[index] == 0) {
                DataStore.selectionOfCategory[index] = 1;
              } else {
                DataStore.selectionOfCategory[index] = 0;
              }
            });
          },
          child: Chip(
            backgroundColor: (DataStore.selectionOfCategory[index] == 1)
                ? Colors.grey[400]
                : Colors.pink[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            label: Text(
              label,
              style: TextStyle(
                color: (DataStore.selectionOfCategory[index] == 1)
                    ? Colors.black
                    : Colors.white,
                fontSize: 15,
              ),
            ),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 3.8,
            ),
          ),
        ),
      ],
    );
  }
}
