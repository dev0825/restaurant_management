import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class ItemPageW extends StatefulWidget {
  const ItemPageW({Key? key}) : super(key: key);

  @override
  State<ItemPageW> createState() => _ItemPageWState();
}

class _ItemPageWState extends State<ItemPageW> {
  final TextEditingController _search = TextEditingController();
  
  preOreder(String itemName) async {
    DocumentReference<Map<String, dynamic>> location = FirebaseFirestore
        .instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .collection("PreOrder")
        .doc(itemName);
    DocumentSnapshot<Map<String, dynamic>> data;
    data = await location.get();
    // Doc Is Not There (Frist Time)
    if (data.data() == null) {
      location.set({
        "Total": 1,
        "Name": itemName,
      });
    }
  }

  updatePreOrder(String itemName, int updateNum) async {
    DocumentReference<Map<String, dynamic>> location = FirebaseFirestore
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Menu:' + DataStore.TableNo,
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
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
                Navigator.pushNamed(context, MyRotues.givenorderpagewRoute);
              },
              child: const Icon(Icons.done_outline_rounded),
            ),
            TextFormField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Search',
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            //Category
            SizedBox(
              height: 90,
              child: FutureBuilder(
                future: DataStore.fetchListCategory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Text(snapshot.error.toString());
                  }
                  if (snapshot.connectionState == ConnectionState.done) {}
                  if (DataStore.category.isEmpty) {
                    return const Center(child: Text("Opp No Data Is There"));
                  } else {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: DataStore.category.length,
                      itemBuilder: (context, index) {
                        return radioButto(
                            DataStore.category[index]["Name"], index);
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(
              height: 300,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: (_search.text == "")
                    ? FirebaseFirestore.instance
                        .collection("Company")
                        .doc(DataStore.hotelCode)
                        .collection("Item")
                        .snapshots()
                    : FirebaseFirestore.instance
                        .collection("Company")
                        .doc(DataStore.hotelCode)
                        .collection("Item")
                        .where("caseSearch",
                            arrayContains: _search.text.toLowerCase())
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: (_search.text == "")
                          ? const CircularProgressIndicator()
                          : const Text(""),
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
                            onTap: () {
                              preOreder(snapshot.data!.docs[index]["Name"]);
                            },
                            child: ListTile(
                              title: Text(
                                snapshot.data!.docs[index]["Name"],
                                style: TextStyle(
                                  fontSize: 20,
                                  color: tablecolor,
                                ),
                              ),
                              subtitle: Text(
                                  snapshot.data!.docs[index]["Category"][0]),
                              trailing: Text(" ₹ " +
                                  snapshot.data!.docs[index]["Purchase Price"]
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
          ],
        ),
      ),
    );
  }

  Widget radioButto(String label, int index) {
    return Row(
      children: [
        const SizedBox(
          width: 30,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              _search.text = label;
            });
          },
          child: Chip(
            backgroundColor: Colors.pink[400],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            label: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            labelPadding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 3.8,
            ),
          ),
        ),
      ],
    );
  }
}
