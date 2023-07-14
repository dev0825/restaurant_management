import 'dart:async';

import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class CategoryExpense extends StatefulWidget {
  const CategoryExpense({Key? key}) : super(key: key);

  @override
  _CategoryExpenseState createState() => _CategoryExpenseState();
}

class _CategoryExpenseState extends State<CategoryExpense> {
  FutureOr onGoBack(dynamic value) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Category"),
      ),
      // body: ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DataStore.addExpanseCategory = true;
          Navigator.pushNamed(context, MyRotues.addcategoryRoute)
              .then(onGoBack);
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder(
        future: DataStore.fetchListExpenseCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (DataStore.expenseCategory.isEmpty) {
            return const Center(child: Text("Opp No Data Is There"));
          } else {
            return GridView.builder(
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 25.0),
              itemCount: DataStore.expenseCategory.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    nextPage(DataStore.expenseCategory[index]);
                  },
                  child: Column(
                    children: [
                      SizedBox(
                          height: 100,
                          child: Image.network(
                              DataStore.expenseCategoryUrl[index])),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(DataStore.expenseCategory[index]),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
  void nextPage(String categroy) {
    if (categroy == "Electricty") {
      Navigator.pushNamed(context, MyRotues.expenseElectricityRoute);
    }
    if (categroy == "Salray") {
      Navigator.pushNamed(context, MyRotues.expenseSalrayRoute);
    }
  }
}
