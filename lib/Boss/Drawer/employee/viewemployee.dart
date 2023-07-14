import 'dart:async';
import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class Viewemployee extends StatefulWidget {
  const Viewemployee({Key? key}) : super(key: key);

  @override
  _ViewemployeeState createState() => _ViewemployeeState();
}

class _ViewemployeeState extends State<Viewemployee> {
  FutureOr onGoBack(dynamic value) async {
    setState(() {});
  }

  // padding: EdgeInsets.fromLTRB(0, 0, 15, 0),

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('View Employee'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRotues.exEmployeeRoute);
            },
            icon: const Icon(Icons.emoji_people_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, MyRotues.addemployeeRoute)
              .then(onGoBack);
        },
        child: const Icon(Icons.navigation),
        backgroundColor: Colors.cyan,
      ),
      body: FutureBuilder(
        future: DataStore.fetchListProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (DataStore.profile.isEmpty) {
            return const Center(child: Text("Opp No Data Is There"));
          } else {
            return ListView.builder(
              itemCount: DataStore.profile.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: ExpansionTile(
                    leading: Image.network(DataStore.profile[index]["Image"]),
                    title: Text(
                      DataStore.profile[index]["Name"],
                      style: const TextStyle(fontSize: 20),
                    ),
                    backgroundColor: Colors.black12,
                    children: [
                      ListTile(
                        title: Text(DataStore.profile[index]["Position"]),
                        subtitle: Text(DataStore.profile[index]["Moblie No"]),
                        trailing: Text(DataStore.profile[index]["User Name"]),
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