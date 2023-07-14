import 'dart:async';

import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class Viewitem extends StatefulWidget {
  const Viewitem({Key? key}) : super(key: key);

  @override
  _ViewitemState createState() => _ViewitemState();
}

class _ViewitemState extends State<Viewitem> {
  FutureOr onGoBack(dynamic value) async {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('View Item'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRotues.additemRoute).then(onGoBack);
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.cyan,
      ),
        body: FutureBuilder(
        future: DataStore.fetchListItem(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (DataStore.item.isEmpty) {
            return const Center(child: Text("Opp No Data Is There"));
          } else {
            return ListView.builder(
              itemCount: DataStore.item.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: ExpansionTile(
                    leading: Image.network(DataStore.item[index]["Image"]),
                    title: Text(
                      DataStore.item[index]["Name"],
                      style: const TextStyle(fontSize: 20),
                    ),
              subtitle: Text(" ₹ " + DataStore.item[index]["Purchase Price"]),
                    backgroundColor: Colors.black12,
                    children: [
                      ListTile(
                        title: Text(DataStore.item[index]["Desciption"]),
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