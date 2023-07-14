import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../DataBase.dart';

class ElectrictyExpense extends StatefulWidget {
  const ElectrictyExpense({Key? key}) : super(key: key);

  @override
  _ElectrictyExpenseState createState() => _ElectrictyExpenseState();
}

class _ElectrictyExpenseState extends State<ElectrictyExpense> {
  // DateTime selectedDate = DateTime.now();
  String selectedDate =
      DateFormat("yyyy-MM-dd hh:mm:ss").format(DateTime.now());
  final TextEditingController _bill = TextEditingController();
  static List month = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Electricty"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButton<String>(
              items: DataStore.yearListElectricty.map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              value: DataStore.cyear,
              onChanged: (year) {
                setState(() {
                  DataStore.cyear = year.toString();
                });
              },
            ),
            SizedBox(
              height: 700,
              child: FutureBuilder(
                future: DataStore.fetchElectricty(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  } else if (DataStore.electrictypayStatus.isEmpty) {
                    return const Center(child: Text("Opp No Data Is There"));
                  } else {
                    return ListView.builder(
                      itemCount: month.length,
                      itemBuilder: (context, index) {
                        Color tablecolor;
                        bool isPaid;
                        if (DataStore.electrictypayStatus[index] == "Paid") {
                          tablecolor = Colors.green;
                          isPaid = true;
                        } else {
                          tablecolor = Colors.red;
                          isPaid = false;
                        }
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                          child: ExpansionTile(
                            title: Text(
                              month[index],
                              style: TextStyle(
                                fontSize: 20,
                                color: tablecolor,
                              ),
                            ),
                            backgroundColor: Colors.black12,
                            children: [
                              (isPaid)
                                  ? ListTile(
                                      title: Text(DataStore.electrictybill[index]
                                              .toString() +
                                          " ₹"),
                                      subtitle: Text(DataStore
                                          .electrictyDate[index]
                                          .toString()),
                                      // trailing: Text(DataStore.profile[index]["User Name"]),
                                    )
                                  : Column(
                                      children: [
                                        ListTile(
                                          title: TextFormField(
                                            controller: _bill,
                                            decoration: const InputDecoration(
                                              hintText: 'eg : 0 ₹',
                                            ),
                                            //for Only Input Of Number
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ], // Only numbers can be entered
                                            validator: (String? value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please enter Purchase Price';
                                              }
                                              return null;
                                            },
                                          ),
                                          // trailing: Text(DataStore.profile[index]["User Name"]),
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              addBill(index);
                                            },
                                            child: const Text("Add"))
                                      ],
                                    )
                            ],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addBill(int index) async {
    DataStore.electrictypayStatus[index] = "Paid";
    DataStore.electrictyDate[index] = selectedDate;
    DataStore.electrictybill[index] = int.parse(_bill.text);
    _bill.text = "";
    await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("PL")
        .doc("Loss")
        .collection("Electricty")
        .doc(DataStore.cyear)
        .update({
      "Bill": DataStore.electrictybill,
      "Date": DataStore.electrictyDate,
      "payStatus": DataStore.electrictypayStatus,
    }).whenComplete(() {
      setState(() {});
    });
  }
}
