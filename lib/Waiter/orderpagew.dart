import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';

class OrderPageW extends StatelessWidget {
  const OrderPageW({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child:Container(
          height: 500,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance
                    .collection("Company")
                    .doc(DataStore.hotelCode)
                    .collection("Table")
                    .doc(DataStore.TableNo)
                    .collection("Order")
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
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                          child: GestureDetector(
                            onTap: () {},
                            child: ListTile(
                              title: Text(
                                snapshot.data!.docs[index]["Name"],
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              subtitle: Text(snapshot.data!.docs[index]["Count"]
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
      ),
    );
  }
}
