import 'dart:async';

import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class Viewcategory extends StatefulWidget {
  const Viewcategory({Key? key}) : super(key: key);

  @override
  _ViewcategoryState createState() => _ViewcategoryState();
}

class _ViewcategoryState extends State<Viewcategory> {
  FutureOr onGoBack(dynamic value) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('View Category'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRotues.addcategoryRoute)
              .then(onGoBack);
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder(
        future: DataStore.fetchListCategory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (DataStore.category.isEmpty) {
            return const Center(child: Text("Opp No Data Is There"));
          } else {
            return ListView.builder(
              itemCount: DataStore.category.length,
              itemBuilder: (context, index) {
                
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: ExpansionTile(
                    leading: Image.network(DataStore.category[index]["Image"]),
                    title: Text(
                      DataStore.category[index]["Name"],
                      style: const TextStyle(fontSize: 20),
                    ),
                    backgroundColor: Colors.black12,
                    children: [
                      ListTile(
                        title: Text(DataStore.category[index]["Desciption"]),
                      )
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
}
