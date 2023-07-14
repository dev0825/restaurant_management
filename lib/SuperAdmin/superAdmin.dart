import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class super_admin extends StatefulWidget {
  const super_admin({Key? key}) : super(key: key);

  @override
  _super_adminState createState() => _super_adminState();
}

class _super_adminState extends State<super_admin> {
  late QuerySnapshot<Map<String, dynamic>> data;
  getData() async {
    data = await FirebaseFirestore.instance.collection("SuperAdmin").get();
    print(data.size);
    data.size;
  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            //Company  Name
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Company Name',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Item Name';
                }
                return null;
              },
            ),
            // Owner Email
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Owner Email',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Item Name';
                }
                return null;
              },
            ),
            // Owner Password
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Owner Password',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Item Name';
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
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
