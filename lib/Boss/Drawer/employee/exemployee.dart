import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';

class Exemployee extends StatelessWidget {
  const Exemployee({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('ahi badha employee show karva'),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Icon(
              Icons.emoji_people_outlined,
            ),
          )
        ],
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