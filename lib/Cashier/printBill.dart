import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premium_hotels/DataBase.dart';

class PrintBill extends StatefulWidget {
  const PrintBill({Key? key}) : super(key: key);
  @override
  _PrintBillState createState() => _PrintBillState();
}

class _PrintBillState extends State<PrintBill> {
  @override
  void initState() {
    backendProcess();
    super.initState();
  }

  backendProcess() async {
    String cyear = DateFormat("yyyy").format(DateTime.now());
    String cmonth = DateFormat("MM").format(DateTime.now());
    String cday = DateFormat("dd").format(DateTime.now());
    String ctime = DateFormat("hhmmss").format(DateTime.now());
    if (DataStore.TableNo.length == 1) {
      DataStore.TableNo = '0' + DataStore.TableNo;
    }
    Map<dynamic, dynamic> HistroyMap =
        Map.fromIterables(DataStore.itemName, DataStore.itemQutity);
    DocumentReference<Map<String, dynamic>> history = FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("History")
        .doc(cyear + cmonth + cday + ctime + DataStore.TableNo);
    history.set({
      "Food": HistroyMap,
      "Name": DataStore.billName,
      "Contact Number": DataStore.billPhoneNumber,
      "Payment Method": DataStore.paymentMethod,
      "Total Price": DataStore.totalPrice,
      "Grand Total": DataStore.grandTotal,
    });
    DocumentReference<Map<String, dynamic>> years = FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("PL")
        .doc("Profit")
        .collection("Year")
        .doc(cyear);
    DocumentReference<Map<String, dynamic>> month =
        years.collection("month").doc(cmonth);
    DocumentReference<Map<String, dynamic>> days =
        month.collection("Days").doc(cday);
    DocumentSnapshot<Map<String, dynamic>> daysData = await days.get();
    DocumentSnapshot<Map<String, dynamic>> monthData = await month.get();
    DocumentSnapshot<Map<String, dynamic>> yearData = await years.get();
    Map<String, dynamic> dayMap = daysData["Items"];
    Map<String, dynamic> monthMap = monthData["Items"];
    Map<String, dynamic> yearMap = yearData["Items"];

    for (var i = 0; i < DataStore.itemName.length; i++) {
      dayMap.putIfAbsent(DataStore.itemName[i], () => 0);
      monthMap.putIfAbsent(DataStore.itemName[i], () => 0);
      yearMap.putIfAbsent(DataStore.itemName[i], () => 0);
      int td =
          dayMap[DataStore.itemName[i]] + int.parse(DataStore.itemQutity[i]);
      int tm =
          monthMap[DataStore.itemName[i]] + int.parse(DataStore.itemQutity[i]);
      int ty =
          yearMap[DataStore.itemName[i]] + int.parse(DataStore.itemQutity[i]);
      dayMap[DataStore.itemName[i]] = td;
      monthMap[DataStore.itemName[i]] = tm;
      yearMap[DataStore.itemName[i]] = ty;
    }
    await days.update({
      "Items": dayMap,
    });
    await month.update({
      "Items": monthMap,
    });
    await years.update({
      "Items": yearMap,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Print"),
        centerTitle: true,
        backgroundColor: const Color(0xfffe9721),
      ),
    );
  }
}
