import 'dart:io';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:premium_hotels/DataBase.dart';

//name
//username
//set password
//age
//gender
//email
//photu
//salery
//mobile no
//department
//position
//parttime/fulltime (radio button)
//joining date
//address

class Addemployee extends StatefulWidget {
  const Addemployee({Key? key}) : super(key: key);

  @override
  State<Addemployee> createState() => _AddemployeeState();
}

class _AddemployeeState extends State<Addemployee> {
  DateTime selectedDate = DateTime.now();

  final TextEditingController _dateController = TextEditingController();

  final TextEditingController _name = TextEditingController();

  // TextEditingController _age = TextEditingController();

  // TextEditingController _gender = TextEditingController();

  final TextEditingController _username = TextEditingController();

  final TextEditingController _password = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _salery = TextEditingController();

  final TextEditingController _moblieNo = TextEditingController();

  // TextEditingController _postion = TextEditingController();

  // TextEditingController _joiningdate = TextEditingController();

  final TextEditingController _address = TextEditingController();
  File localImagePath = File("");
  String imageUrl = "";
  DateTime _dateTime = DateTime.now();
  String _postion = "";
  String _gender = "Male";
  List selectedCategory = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(1901),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(
        () {
          selectedDate = picked;
          _dateController.text =
              formatDate(selectedDate, [yyyy, '-', mm, '-', dd]);
        },
      );
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
        setState(
          () {
            DataStore.isImageSelected = true;
            localImagePath = file;
            // print("Selcting Image : " + localImagePath.path);
            // print(localImagePath);
          },
        );
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
    // print("1 Before");
    final _storage = FirebaseStorage.instance;
    if (localImagePath.path != null) {
      // print("2 Before");
      // print(localImagePath.path);
      if (DataStore.isImageSelected) {
        var snapshot = await _storage
            .ref()
            .child('01/Profile/' + _username.text + '.jpg')
            .putFile(localImagePath)
            .whenComplete(() => print("Done"));
        uploadImageUrl = await snapshot.ref.getDownloadURL();
        print("Hey");
        // print(imageUrl);
      } else {
        if (_gender == "Male") {
          uploadImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/hotel-premium-c357d.appspot.com/o/Profile%2Fmale.jpg?alt=media&token=524af257-73ae-4492-a338-1f1b42865279";
          // "https://firebasestorage.googleapis.com/v0/b/premium-hotel-94013.appspot.com/o/Profile%2FMale.jpg?alt=media&token=a1a42627-1cbc-40cc-93e1-8d4f2b99bb59";
        } else {
          uploadImageUrl =
              "https://firebasestorage.googleapis.com/v0/b/hotel-premium-c357d.appspot.com/o/Profile%2Ffemale.jpg?alt=media&token=1d56329e-96a7-4d80-af93-2185ad95c3d5";
          // "https://firebasestorage.googleapis.com/v0/b/premium-hotel-94013.appspot.com/o/Profile%2FFemale.jpg?alt=media&token=5ec90a3f-6a2a-46ba-b71f-6fac944061b0";
        }
      }
      setState(() {
        imageUrl = uploadImageUrl;
        print(imageUrl);
      });
      newProfile();
    } else {
      // print('No Path Received');
    }
  }

  void newProfile() async {
    try {
      // Sign Up
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _username.text + "@gmail.com", password: _password.text);
      var uid = FirebaseAuth.instance.currentUser!.uid.characters;
      await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("Profile")
          .doc(uid.toString())
          .set(
        {
          "Name": _name.text,
          "Birth Date": _dateController.text,
          "Gender": _gender,
          "User Name": _username.text,
          "Image": imageUrl,
          "Email": _email.text,
          "Salery": _salery.text,
          "Moblie No": _moblieNo.text,
          "Position": _postion,
          "Date of Joining": _dateTime,
          "Address": _address.text,
          "Category": selectedCategory,
        },
      ).then(
        (value) async {
          DataStore.isImageSelected = false;
          Navigator.pop(context);
        },
      );
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Add Emloyee'),
        centerTitle: true,
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //name
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                hintText: 'Enter Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            //Age
            // TextFormField(
            //   controller: _age,
            //   decoration: const InputDecoration(
            //     hintText: 'Enter Age',
            //   ),
            //   keyboardType: TextInputType.number,
            //   inputFormatters: <TextInputFormatter>[
            //     FilteringTextInputFormatter.digitsOnly
            //   ], // Only numbers can be entered
            //   validator: (String? value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Please enter some text';
            //     }
            //     return null;
            //   },
            // ),
            const SizedBox(
              height: 20,
            ),
            TextButton.icon(
              onPressed: () {
                _selectDate(context);
              },
              icon: const Icon(Icons.date_range_rounded),
              label: Text(
                "Date Of Birth   :   " +
                    formatDate(selectedDate, [yyyy, '-', mm, '-', dd]),
                style: const TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),

            const SizedBox(
              height: 50,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Gender",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                gender("Male"),
                const SizedBox(
                  width: 10,
                ),
                gender("Female"),
              ],
            ),
            //Username
            TextFormField(
              controller: _username,
              decoration: InputDecoration(
                hintText: DataStore.hotelCode + '...',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            //password
            TextFormField(
              controller: _password,
              decoration: const InputDecoration(
                hintText: 'Enter Password for Employee',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            //email
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(
                hintText: 'Enter Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            //photu
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SizedBox(
                    height: 180,
                    width: 180,
                    child: (!DataStore.isImageSelected)
                        ? (_gender == "Male")
                            ? Image.asset("assets/images/user-male.png")
                            : Image.asset("assets/images/user-female.png")
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
            //salery
            TextFormField(
              controller: _salery,
              decoration: const InputDecoration(
                hintText: 'Enter salery',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            //mobile no
            TextFormField(
              controller: _moblieNo,
              decoration: const InputDecoration(
                hintText: 'Mobile No',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            //department
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Department after',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 50,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Postion",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                radioButton("Chef"),
                const SizedBox(
                  width: 10,
                ),
                radioButton("Manager"),
                const SizedBox(
                  width: 10,
                ),
                radioButton("Waiter"),
              ],
            ),
            SizedBox(
              height: 90,
              child: (_postion == "Chef")
                  ? FutureBuilder(
                      future: DataStore.fetchListCategory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          return const Center(
                              child: Text("Opp No Data Is There"));
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
                    )
                  : const Text(" "),
            ),
            //parttime/fulltime (radio button)
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter job Type after',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                initialDateTime: _dateTime,
                onDateTimeChanged: (selectDateTime) {
                  // print(selectDateTime);
                  setState(
                    () {
                      _dateTime = selectDateTime;
                    },
                  );
                },
              ),
            ),
            //address
            TextFormField(
              controller: _address,
              decoration: const InputDecoration(
                hintText: 'Enter Address',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            ElevatedButton(
                onPressed: () {
                  // NewProfile();
                  // print("Slected ");
                  afterPressedSelectedCatagory();
                  // uploadImage();
                  // print("1 Slected");
                },
                child: const Text("Sing Up")),
          ],
        ),
      ),
    );
  }

  Widget radioButton(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _postion = label;
        });
      },
      child: Chip(
        backgroundColor:
            (_postion == label) ? Colors.grey[400] : Colors.pink[400],
        // (_postion == label) ? Colors.amber[200] : Colors.pink[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(
          label,
          style: TextStyle(
            color: (_postion == label) ? Colors.black : Colors.white,
            fontSize: 15,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
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

  Widget gender(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = label;
        });
      },
      child: Chip(
        backgroundColor:
            (_gender == label) ? Colors.grey[400] : Colors.pink[400],
        // (_gender == label) ? Colors.amber[200] : Colors.pink[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(
          label,
          style: TextStyle(
            color: (_gender == label) ? Colors.black : Colors.white,
            fontSize: 15,
          ),
        ),
        labelPadding: const EdgeInsets.symmetric(
          horizontal: 17,
          vertical: 3.8,
        ),
      ),
    );
  }
}
