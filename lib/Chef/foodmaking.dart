import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:premium_hotels/Chef/chefdrawer.dart';
import 'package:premium_hotels/DataBase.dart';

class Foodmakingchef extends StatefulWidget {
  const Foodmakingchef({Key? key}) : super(key: key);

  @override
  _FoodmakingchefState createState() => _FoodmakingchefState();
}

class _FoodmakingchefState extends State<Foodmakingchef> {
  String currentuid = DataStore.uid;
  // String currentuid = "rPlZ6PeiJFRv6XdjEkRybmFTU8l1";
  // String currentuid = "rPlZ6PeiJFRv6XdjEkRybmFTU8l2";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Pending Making Food',
        ),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      drawer: const ChefDrawer(),
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
                      .where("Category", arrayContainsAny:DataStore.chefCategory)
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
                            // bool islike = snapshot.data!.docs[index]["isLike"];
                            String UID = snapshot.data!.docs[index]["UID"];
                            return (UID == "0" || currentuid == UID)
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
                                                              {"UID": currentuid})
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
                                                          .update({"UID": "0"});

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
                                                  // await FirebaseFirestore
                                                  //     .instance
                                                  //     .collection("Company")
                                                  //     .doc(DataStore.hotelCode)
                                                  //     .collection("Chef")
                                                  //     .doc(snapshot.data!
                                                  //                 .docs[index]
                                                  //             ["Table No"] +
                                                  //         "_" +
                                                  //         snapshot.data!
                                                  //                 .docs[index]
                                                  //             ["Name"])
                                                  //     .delete();
                                                  (UID != "0")
                                                      ? await FirebaseFirestore
                                                          .instance
                                                          .collection("Company")
                                                          .doc(DataStore.hotelCode)
                                                          .collection("Chef")
                                                          .doc(snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ["Table No"] +
                                                              "_" +
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ["Name"])
                                                          .update({"UID": "1"})
                                                      : ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                          SnackBar(
                                                            backgroundColor:
                                                                Colors
                                                                    .cyan[100],
                                                            content: const Text(
                                                              'dofa jeva pela k to khara k aa foof hu banavu 6u and bani jai pa6i submit karje baki waiter moti moti gado dese ...',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                        );
                                                },
                                                icon: const Icon(Icons.done)),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                : Container();
                          },);
                    }
                  },),
            )
          ],
        ),
      ),
    );
  }
}















   // // var docname =
                                                    //     await FirebaseFirestore
                                                    //         .instance
                                                    //         .collection(
                                                    //             "Company")
                                                    //         .doc(DataStore.hotelCode)
                                                    //         .collection("Chef")
                                                    //         .doc(snapshot.data!
                                                    //                         .docs[
                                                    //                     index][
                                                    //                 "Table No"] +
                                                    //             "_" +
                                                    //             snapshot.data!
                                                    //                         .docs[
                                                    //                     index]
                                                    //                 ["Name"])
                                                    //         .update({
                                                    //   "isLike": !islike
                                                    // });

                                                    // (islike == false)
                                                    //     ? await FirebaseFirestore
                                                    //         .instance
                                                    //         .collection(
                                                    //             "Company")
                                                    //         .doc(DataStore.hotelCode)
                                                    //         .collection("Chef")
                                                    //         .doc(snapshot.data!.docs[index]["Table No"] +
                                                    //             "_" +
                                                    //             snapshot.data!
                                                    //                     .docs[index]
                                                    //                 ["Name"])
                                                    //         .update(
                                                    //             {"uid": currentuid})
                                                    //     : await FirebaseFirestore
                                                    //         .instance
                                                    //         .collection(
                                                    //             "Company")
                                                    //         .doc(DataStore.hotelCode)
                                                    //         .collection("Chef")
                                                    //         .doc(snapshot.data!
                                                    //                     .docs[index]
                                                    //                 ["Table No"] +
                                                    //             "_" +
                                                    //             snapshot.data!.docs[index]["Name"])
                                                    //         .update({"uid": ""});




                                                        // (islike == false)
                                                    //     ? await FirebaseFirestore
                                                    //         .instance
                                                    //         .collection(
                                                    //             "Company")
                                                    //         .doc(DataStore.hotelCode)
                                                    //         .collection("Chef")
                                                    //         .doc(snapshot.data!.docs[index]["Table No"] +
                                                    //             "_" +
                                                    //             snapshot.data!
                                                    //                     .docs[index]
                                                    //                 ["Name"])
                                                    //         .update(
                                                    //             {"uid": currentuid})
                                                    //     : await FirebaseFirestore
                                                    //         .instance
                                                    //         .collection(
                                                    //             "Company")
                                                    //         .doc(DataStore.hotelCode)
                                                    //         .collection("Chef")
                                                    //         .doc(snapshot.data!
                                                    //                     .docs[index]
                                                    //                 ["Table No"] +
                                                    //             "_" +
                                                    //             snapshot.data!.docs[index]["Name"])
                                                    //         .update({"uid": ""});