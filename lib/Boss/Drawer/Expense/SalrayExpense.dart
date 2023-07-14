import 'package:flutter/material.dart';

import '../../../DataBase.dart';

class SalrayExpense extends StatefulWidget {
  const SalrayExpense({Key? key}) : super(key: key);

  @override
  _SalrayExpenseState createState() => _SalrayExpenseState();
}

class _SalrayExpenseState extends State<SalrayExpense> {
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
        title: const Text("Salary"),
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
              child: ListView.builder(
                itemCount: month.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(month[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
