import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';

import '../routes.dart';
import 'drawerwaiter.dart';

class PendingDeliveryW extends StatefulWidget {
  const PendingDeliveryW({Key? key}) : super(key: key);

  @override
  State<PendingDeliveryW> createState() => _PendingDeliveryWState();
}

class _PendingDeliveryWState extends State<PendingDeliveryW> {
  String currentuid = DataStore.uid;
  // String currentuid = "rPlZ6PeiJFRv6XdjEkRybmFTU8l2";
  // String currentuid = "rPlZ6PeiJFRv6XdjEkRybmFTU8l1";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Pending Delivery',
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      //upar nu drawer
      drawer: const DrawerW(),
      // bottomNavigationBar: BottomAppBar(
      //   elevation: 15,
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 12.0,
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //     children: <Widget>[
      //       IconButton(
      //         icon: const Icon(
      //           Icons.filter_list,
      //         ),
      //         onPressed: () {
      //           Navigator.pushNamed(context, MyRotues.choosetablewRoute);
      //         },
      //       ),
      //       const SizedBox(width: 48.0),
      //       IconButton(
      //         icon: const Icon(
      //           Icons.show_chart,
      //         ),
      //         onPressed: () {},
      //       ),
      //     ],
      //   ),
      // ),
      //icon only and only saru lagadva matenu chhe baki kai kam nu nathi
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: const Icon(
      //     Icons.home_work_outlined,
      //     size: 35,
      //   ),
      //   onPressed: () {},
      //   backgroundColor: Colors.cyan,
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height - 20,
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("Company")
                      .doc(DataStore.hotelCode)
                      .collection("Chef")
                      // .where("Category", arrayContainsAny: ChefCategory)
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
                            String UID =
                                snapshot.data!.docs[index]["waiterUid"];
                            String ChefUID = snapshot.data!.docs[index]["UID"];
                            return ((ChefUID == "1") &&
                                    (UID == "0" || currentuid == UID))
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    // height: 100,
                                    color: Colors.amber,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                                "Table no : ${snapshot.data!.docs[index]["Table No"]}"),
                                            const Spacer(),
                                            const Text("order Time"),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            CircleAvatar(
                                                child: Image.network(
                                              "https://firebasestorage.googleapis.com/v0/b/hotel-premium-c357d.appspot.com/o/Profile%2Fmale.jpg?alt=media&token=524af257-73ae-4492-a338-1f1b42865279",
                                              fit: BoxFit.scaleDown,
                                            )),
                                            Text(snapshot.data!.docs[index]
                                                ["Name"]),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Text(
                                              "Total Item : ${snapshot.data!.docs[index]["Item Contain"].toString()}",
                                            ),
                                            const Spacer()
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            IconButton(
                                                onPressed: () async {
// ======================================================================================================================

                                                  (UID == "0")
                                                      ? await FirebaseFirestore
                                                          .instance
                                                          .collection("Company")
                                                          .doc(DataStore.hotelCode)
                                                          .collection("Chef")
                                                          .doc(snapshot.data!.docs[index]
                                                                  ["Table No"] +
                                                              "_" +
                                                              snapshot.data!.docs[index]
                                                                  ["Name"])
                                                          .update(
                                                              {"waiterUid": currentuid})
                                                      : await FirebaseFirestore
                                                          .instance
                                                          .collection("Company")
                                                          .doc(DataStore.hotelCode)
                                                          .collection("Chef")
                                                          .doc(snapshot.data!
                                                                      .docs[index]
                                                                  ["Table No"] +
                                                              "_" +
                                                              snapshot.data!
                                                                  .docs[index]["Name"])
                                                          .update({"waiterUid": "0"});

// ======================================================================================================================
                                                  // ------------------- this is get uid of user ----------------------

                                                  // try {
                                                  //   final FirebaseAuth auth =
                                                  //       FirebaseAuth.instance;
                                                  //   var st = auth.currentUser?.uid;
                                                  //   // final Future<User> user = auth.currentUser();
                                                  //   print("this is auth : $st");
                                                  // } catch (e) {
                                                  //   print("this is error $e");
                                                  // }
                                                  // ----------------------------------------------------------------------------
                                                },
                                                icon: (UID != "0")
                                                    ? Icon(Icons.star)
                                                    : Icon(Icons.star_border)),
                                            IconButton(
                                                onPressed: () async {
                                                  if (UID != "0") {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Company")
                                                        .doc(DataStore.hotelCode)
                                                        .collection("Table")
                                                        .doc(snapshot.data!
                                                                    .docs[index]
                                                                ["Table No"]
                                                           ).collection("Order").doc(
                                                             snapshot.data!
                                                                    .docs[index]
                                                                ["Name"]
                                                           )
                                                          .update({"Pending": 0});
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("Company")
                                                        .doc(DataStore.hotelCode)
                                                        .collection("Chef")
                                                        .doc(snapshot.data!
                                                                    .docs[index]
                                                                ["Table No"] +
                                                            "_" +
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ["Name"])
                                                        .delete();
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        backgroundColor:
                                                            Colors.cyan[100],
                                                        content: const Text(
                                                          'dofa jeva pela k to khara k aa foof hu banavu 6u and bani jai pa6i submit karje baki waiter moti moti gado dese ...',
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                },
                                                icon: const Icon(Icons.done)),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                // : Text("");
                                : Container();
                          });
                    }
                  }),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, String table_no) {
    return AlertDialog(
      title: const Text('Popup example'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
              "lagga to aa order table number : $table_no par deva jaish ee paku j 6 ne"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          // textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
