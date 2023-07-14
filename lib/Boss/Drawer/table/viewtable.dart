import 'dart:async';
import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class ViewTable extends StatefulWidget {
  const ViewTable({Key? key}) : super(key: key);

  @override
  _ViewTableState createState() => _ViewTableState();
}

class _ViewTableState extends State<ViewTable> {
  FutureOr onGoBack(dynamic value) async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('View Table'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRotues.addtableRoute)
              .then(onGoBack);
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder(
        future: DataStore.fetchListTable(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (DataStore.Table.isEmpty) {
            return const Center(child: Text("Opp No Table is Created"));
          } else {
            return ListView.builder(
              itemCount: DataStore.Table.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: ExpansionTile(
                    title: Text(
                      "Table Number  "+
                      DataStore.Table[index]["Table Number"].toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                    backgroundColor: Colors.black12,
                    children: [
                      ListTile(
                        title: Text(
                      "Capacity : "+
                      DataStore.Table[index]["Table Capacity"].toString(),
                      style: const TextStyle(fontSize: 15),
                    ),
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