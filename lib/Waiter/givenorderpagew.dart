import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class GivenOrderPageW extends StatefulWidget {
  const GivenOrderPageW({Key? key}) : super(key: key);

  @override
  State<GivenOrderPageW> createState() => _GivenOrderPageWState();
}

class _GivenOrderPageWState extends State<GivenOrderPageW> {
  occupiedTable() async {
    await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .update({
      "Status": "Occupied",
    });
  }

  updatePreOrder(String itemName, int updateNum) async {
    DocumentReference<Map<String, dynamic>> location = await FirebaseFirestore
        .instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .collection("PreOrder")
        .doc(itemName);
    DocumentSnapshot<Map<String, dynamic>> dataNum = await location.get();
    int totalFirebase = dataNum["Total"];
    int total = totalFirebase + updateNum;
    if (total < 0) {
      total = 0;
    }
    await location.update({
      "Total": total,
    });
  }

  preOrderToChef() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .collection("PreOrder")
        .get();
    
    CollectionReference<Map<String, dynamic>> location = FirebaseFirestore
        .instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Chef");
    CollectionReference<Map<String, dynamic>> locationOfItem = FirebaseFirestore
        .instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Item");
        // .doc(DataStore.TableNo+"_")
    for (var i = 0; i < data.size; i++) {
      DocumentSnapshot<Map<String, dynamic>> checking;
      DocumentSnapshot<Map<String, dynamic>> ArrayOfCatagory;
      checking = await location.doc(DataStore.TableNo+"_"+data.docs[i]["Name"]).get();
      ArrayOfCatagory = await locationOfItem.doc(data.docs[i]["Name"]).get();
      // Doc Is Not There (Frist Time)
      if (checking.data() == null) {
        location.doc(DataStore.TableNo+"_"+data.docs[i]["Name"]).set({
          "Item Contain": 0,
          "Name": data.docs[i]["Name"],
          "Category":ArrayOfCatagory["Category"],
          "Table No": DataStore.TableNo,
          // "Chef Completed":false,
          // "Waiter Completed":false,
          "UID": "0",
          "waiterUid":"0"
        });
      }
      await updateOrderChef(data.docs[i]["Name"], data.docs[i]["Total"]);
    }
  }
  updateOrderChef(String name, int updateNum) async {
    DocumentReference<Map<String, dynamic>> location = await FirebaseFirestore
        .instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Chef")
        .doc(DataStore.TableNo+"_"+name);
    DocumentSnapshot<Map<String, dynamic>> dataNum = await location.get();
    int totalFirebase = dataNum["Item Contain"];
    int total = totalFirebase + updateNum;
    await location.update({
      "Item Contain": total,
    });
    
  }
  preOrderToOrder() async {
    QuerySnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .collection("PreOrder")
        .get();
    CollectionReference<Map<String, dynamic>> location = await FirebaseFirestore
        .instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .collection("Order");
    for (var i = 0; i < data.size; i++) {
      DocumentSnapshot<Map<String, dynamic>> checking;
      DocumentSnapshot<Map<String, dynamic>> Item = await FirebaseFirestore
          .instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("Item")
          .doc(data.docs[i]["Name"])
          .get();
      checking = await location.doc(data.docs[i]["Name"]).get();
      // Doc Is Not There (Frist Time)
      if (data.docs[i]["Total"] > 0) {
      if (checking.data() == null) {
        location.doc(data.docs[i]["Name"]).set({
          "Count": 0,
          "Name": data.docs[i]["Name"],
          "Pending": 0,
          "Price":int.parse(Item["Purchase Price"]),
        });
      }
      await updateOrder(data.docs[i]["Name"], data.docs[i]["Total"]);
      await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("Table")
          .doc(DataStore.TableNo)
          .collection("PreOrder")
          .doc(data.docs[i]["Name"])
          .delete();
      }
      await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("Table")
          .doc(DataStore.TableNo)
          .collection("PreOrder")
          .doc(data.docs[i]["Name"])
          .delete();
    }
  }

  updateOrder(String name, int updateNum) async {
    DocumentReference<Map<String, dynamic>> location = await FirebaseFirestore
        .instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .collection("Order")
        .doc(name);
    DocumentSnapshot<Map<String, dynamic>> dataNum = await location.get();
    int totalFirebaseCount = dataNum["Count"];
    int totalCount = totalFirebaseCount + updateNum;
    int totalFirebasePending = dataNum["Pending"];
    int totalPending = totalFirebasePending + updateNum;
    await location.update({
      "Count": totalCount,
      "Pending": totalPending,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Given Orders',
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 700,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("Company")
                    .doc(DataStore.hotelCode)
                    .collection("Table")
                    .doc(DataStore.TableNo)
                    .collection("PreOrder")
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
                    return const Center(
                        child: Text("Opp Item Is Not Available"));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.size,
                      itemBuilder: (context, index) {
                        Color tablecolor;
                        tablecolor = Colors.green;
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                          child: GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              leading: IconButton(
                                  onPressed: () {
                                    updatePreOrder(
                                        snapshot.data!.docs[index]["Name"], 1);
                                  },
                                  icon: const Icon(Icons.add)),
                              trailing: IconButton(
                                  onPressed: () {
                                    updatePreOrder(
                                        snapshot.data!.docs[index]["Name"], -1);
                                  },
                                  icon: const Icon(Icons.minimize_rounded)),
                              title: Text(
                                snapshot.data!.docs[index]["Name"],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: tablecolor,
                                ),
                              ),
                              subtitle: Text(snapshot.data!.docs[index]["Total"]
                                  .toString()),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                occupiedTable();
                Navigator.pushNamedAndRemoveUntil(
                    context, MyRotues.waiterRoute, (route) => false);
                preOrderToChef();
                preOrderToOrder();

              },
              child: Icon(Icons.done_outline_rounded),
            ),
          ],
        ),
      ),
    );
  }
}