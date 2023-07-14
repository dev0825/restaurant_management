import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class ChooseTableW extends StatefulWidget {
  const ChooseTableW({Key? key}) : super(key: key);

  @override
  State<ChooseTableW> createState() => _ChooseTableWState();
}

class _ChooseTableWState extends State<ChooseTableW> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Table',
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection("Company")
            .doc(DataStore.hotelCode)
            .collection("Table")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else if (snapshot.data!.size == 0) {
            return const Center(child: Text("Opp No Table is Created"));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                Color tablecolor;
                if (snapshot.data!.docs[index]["Status"] == "Free") {
                  tablecolor = Colors.green;
                } else {
                  //This For Occupied Table
                  tablecolor = Colors.red;
                }
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                  child: GestureDetector(
                    onTap: () {
                      // if (snapshot.data!.docs[index]["Status"] == "Free") {
                      Navigator.pushNamed(context, MyRotues.itempagewRoute);
                      DataStore.TableNo =
                          snapshot.data!.docs[index]["Table Number"].toString();
                      // }
                    },
                    onDoubleTap: () {
                      Navigator.pushNamed(context, MyRotues.orderpagewRoute);
                      DataStore.TableNo =
                          snapshot.data!.docs[index]["Table Number"].toString();
                    },
                    child: ListTile(
                      title: Text(
                        "Table  " +
                            snapshot.data!.docs[index]["Table Number"]
                                .toString(),
                        style: TextStyle(
                          fontSize: 20,
                          color: tablecolor,
                        ),
                      ),
                      subtitle: IconButton(
                          onPressed: () {
                            DataStore.TableNo = snapshot
                                .data!.docs[index]["Table Number"]
                                .toString();
                            Navigator.pushNamed(context, MyRotues.beforeBillRoute);
                          },
                          icon: const Icon(Icons.blur_circular)),
                      trailing: Text("Capacity : " +
                          snapshot.data!.docs[index]["Table Capacity"]
                              .toString()),
                    ),
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
