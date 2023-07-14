import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:premium_hotels/DataBase.dart';

class BeforeBill extends StatefulWidget {
  BeforeBill({Key? key}) : super(key: key);

  @override
  _BeforeBillState createState() => _BeforeBillState();
}

class _BeforeBillState extends State<BeforeBill> {
  String _bill = "";
  final TextEditingController _name = TextEditingController();
  final TextEditingController _moblieNo = TextEditingController();
  UpdateOrder() {
    FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .update(
      {
        "Name": _name.text,
        "Contact Number": _moblieNo.text,
        "Payment Method": _bill,
        "Total Price": DataStore.totalPrice,
        "Grand Total":DataStore.grandTotal.roundToDouble(),
        "Price Clcu": true,
      },
    );
  }

  @override
  void initState() {
    fecthData();
    super.initState();
  }

  fecthData() async {
    QuerySnapshot<Map<String, dynamic>> Order = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .collection("Order")
        .get();
    DataStore.totalPrice = 0;
    for (var i = 0; i < Order.size; i++) {
      int item_Total = Order.docs[i]["Count"] - Order.docs[i]["Pending"];
      int price = Order.docs[i]["Price"];
      DataStore.totalPrice = DataStore.totalPrice + (item_Total * price);
    }
    DataStore.grandTotal = DataStore.totalPrice.toDouble();
    QuerySnapshot<Map<String, dynamic>> Tax = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Tax")
        .get();
    for (var i = 0; i < Tax.size; i++) {
      DataStore.grandTotal = DataStore.grandTotal +
          ((DataStore.totalPrice * Tax.docs[i]["Percentage"]) / 100);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BILL"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              DataStore.grandTotal.toStringAsFixed(2) + " ₹",
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(
              height: 50,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  "Payment Method",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                bill("Cash"),
                const SizedBox(
                  width: 10,
                ),
                bill("Online"),
              ],
            ),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                hintText: 'Name (optinal)',
              ),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _moblieNo,
              decoration: const InputDecoration(
                hintText: 'Mobile No  (optinal)',
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
            ElevatedButton(
                onPressed: () {
                  if (_bill != "") {
                    UpdateOrder();
                    Navigator.pop(context);
                  }
                },
                child: Text(
                  "Bill",
                  style: TextStyle(
                    color: (_bill == "") ? Colors.black : Colors.white,
                    // backgroundColor: (_bill == "") ? Colors.grey[400] : Colors.pink[400],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget bill(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _bill = label;
        });
      },
      child: Chip(
        backgroundColor: (_bill == label) ? Colors.grey[400] : Colors.pink[400],
        // (_bill == label) ? Colors.amber[200] : Colors.pink[400],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        label: Text(
          label,
          style: TextStyle(
            color: (_bill == label) ? Colors.black : Colors.white,
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
