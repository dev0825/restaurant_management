import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:premium_hotels/DataBase.dart';

class Addtable extends StatelessWidget {
  Addtable({Key? key}) : super(key: key);
  final TextEditingController _tableNumber = TextEditingController();
  final TextEditingController _tableCapacity = TextEditingController();

  void newTable(BuildContext context) async {
    try {
      // Sign Up
      await FirebaseFirestore.instance
      .collection("Company").doc(DataStore.hotelCode)
      .collection("Table").doc(_tableNumber.text).set({
        "Table Number": int.parse(_tableNumber.text),
        "Table Capacity":  int.parse(_tableCapacity.text),
        "Status": "Free",
        "Name":"",
        "Payment Method":"",
        "Contact Number":"",
        "Total Price":0,
        "Grand Total":0,
        "Price Clcu":false,
      }).then((value) {
        Navigator.pop(context);
      });
    } catch (e) {
      // print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Add Table'),
        centerTitle: true,
      ),
      body: Form(
          child: ListView(
        children: [
          // Table Number
          TextFormField(
            controller: _tableNumber,
            decoration: const InputDecoration(
              hintText: 'Table Number',
            ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numb
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          // Table Capacity
          TextFormField(
            controller: _tableCapacity,
            decoration: const InputDecoration(
              hintText: 'Table Capacity',
            ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numb
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          Container(
            margin: const EdgeInsets.all(25),
            child: ElevatedButton(
              onPressed: () {
                newTable(context);
              },
              child: const Text('Create Table'),
              style: ElevatedButton.styleFrom(
                shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
