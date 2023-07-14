import 'dart:async';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:premium_hotels/routes.dart';
import '../DataBase.dart';

class Billpage extends StatefulWidget {
  const Billpage({Key? key}) : super(key: key);

  @override
  State<Billpage> createState() => _BillpageState();
}

class _BillpageState extends State<Billpage> {
  @override
  void initState() {
    fecthData();
    // map();
    super.initState();
  }

  map() async {
    DocumentReference<Map<String, dynamic>> years = FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("PL")
        .doc("Profit")
        .collection("Year")
        .doc("2022")
        .collection("month")
        .doc("01");
    // DocumentSnapshot<Map<String, dynamic>> Order = await years.get();
    // print(Order["Items"]["PBM"]);
    await years.update({
      "Items": {"PBM": 30},
    });
    // print(Order["Items"]["PBM"]);
  }

  fecthData() async {
    DataStore.itemName = [];
    DataStore.itemPrice = [];
    DataStore.itemQutity = [];
    DataStore.itemTotalPrice = [];
    DataStore.taxName = [];
    DataStore.taxPercentage = [];
    DataStore.taxPrice = [];
    DataStore.storeData = false;
    // ignore: non_constant_identifier_names
    DocumentSnapshot<Map<String, dynamic>> Order = await FirebaseFirestore
        .instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .doc(DataStore.TableNo)
        .get();
    DataStore.totalPrice = Order["Total Price"];
    DataStore.billName = Order["Name"];
    DataStore.billPhoneNumber = Order["Contact Number"];
    DataStore.paymentMethod = Order["Payment Method"];
    DataStore.grandTotal = Order["Grand Total"].toDouble();
    if (!Order["Price Clcu"]) {
      Navigator.pushNamed(context, MyRotues.beforeBillRoute).then(onGoBack);
    }
    setState(() {
      DataStore.storeData = true;
    });
    String cyear = DateFormat("yyyy").format(DateTime.now());
    String cmonth = DateFormat("MM").format(DateTime.now());
    String cday = DateFormat("dd").format(DateTime.now());
    String ctime = DateFormat("hhmmss").format(DateTime.now());
    DocumentReference<Map<String, dynamic>> years = FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("PL")
        .doc("Profit")
        .collection("Year")
        .doc(cyear);
    DocumentReference<Map<String, dynamic>> month =
        years.collection("month").doc(cmonth);
    DocumentReference<Map<String, dynamic>> days =
        month.collection("Days").doc(cday);
    DocumentSnapshot<Map<String, dynamic>> daysData = await days.get();
    DocumentSnapshot<Map<String, dynamic>> monthData = await days.get();
    DocumentSnapshot<Map<String, dynamic>> yearData = await days.get();
    if (yearData.data() == null) {
      await years.set({
        "Items": {},
      });
    }
    if (monthData.data() == null) {
      await month.set({
        "Items": {},
      });
    }
    if (daysData.data() == null) {
      await days.set({
        "Items": {},
      });
    }
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
        ),
        actions: [
          IconButton(
              onPressed: () {
                if (DataStore.storeData) {
                  Navigator.pushNamed(context, MyRotues.printbillRoutecashier);
                }
              },
              icon: const Icon(Icons.print_rounded))
        ],
        backgroundColor: const Color(0xfffe9721),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                height: MediaQuery.of(context).size.height * 0.800,
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
                      //
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.size,
                        itemBuilder: (context, index) {
                          if (DataStore.storeData) {
                            print("Data Added" + index.toString());
                            DataStore.itemName
                                .add(snapshot.data!.docs[index]["Name"]);
                            DataStore.itemPrice.add(
                                snapshot.data!.docs[index]["Price"].toString());
                            DataStore.itemQutity.add((snapshot.data!.docs[index]
                                        ["Count"] -
                                    snapshot.data!.docs[index]["Pending"])
                                .toString());
                            DataStore.itemTotalPrice.add(((snapshot
                                            .data!.docs[index]["Count"] -
                                        snapshot.data!.docs[index]["Pending"]) *
                                    snapshot.data!.docs[index]["Price"])
                                .toString());
                          }
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
                            //andar nu box
                            child: Container(
                              height: 100,
                              width: MediaQuery.of(context).size.width - 5,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xfffe9721).withOpacity(0.35),
                                border:
                                    Border.all(color: Colors.black, width: 1.2),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                  // topLeft: Radius.circular(30.0),
                                  // bottomRight: Radius.circular(30.0),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(children: [
                                    const Expanded(
                                        flex: 3,
                                        child: Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                15, 10, 15, 10),
                                            child: ClipOval(
                                              child: Image(
                                                  image: AssetImage(
                                                      "assets/images/applogo.jpg"),
                                                  fit: BoxFit.cover),
                                              //aaaaaaaaaaaaaaa
                                              // child: Image(
                                              // image: NetworkImage(
                                              //     DataStore.item[index]
                                              //         ["Image"]),
                                            ))),
                                    Expanded(
                                      flex: 8,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ["Name"],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 3, 0, 0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text(
                                                  "Qty: ${(snapshot.data!.docs[index]["Count"] - snapshot.data!.docs[index]["Pending"]).toString()}",
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  "Price : " +
                                                      snapshot.data!
                                                          .docs[index]["Price"]
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(
                                                130, 2, 40, 2),
                                            child: Divider(
                                              height: 10,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        120, 2, 55, 2),
                                                child: Text(
                                                  "Total: " +
                                                      ((snapshot.data!.docs[
                                                                          index]
                                                                      [
                                                                      "Count"] -
                                                                  snapshot.data!
                                                                              .docs[
                                                                          index]
                                                                      [
                                                                      "Pending"]) *
                                                              snapshot.data!
                                                                          .docs[
                                                                      index]
                                                                  ["Price"])
                                                          .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])
                                ],
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

            //---------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 7, 4, 10),
              child: Container(
                // height: MediaQuery.of(context).size.height,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                  border: Border(
                    top: BorderSide(
                      color: const Color(0xfffe9721),
                      width: 4,
                    ),
                    bottom: BorderSide(
                      color: const Color(0xfffe9721),
                      width: 4,
                    ),
                    left: BorderSide(
                      color: const Color(0xfffe9721),
                      width: 4,
                    ),
                    right: BorderSide(
                      color: const Color(0xfffe9721),
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                          child: Text(
                            "Total : ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 55, 0),
                          child: Text(
                            DataStore.totalPrice.toString(),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("Company")
                          .doc(DataStore.hotelCode)
                          .collection("Tax")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (snapshot.data!.size == 0) {
                          return const Center(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(166, 0, 0, 0),
                            child: Text(
                              "Tax : ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ));
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.size,
                            itemBuilder: (context, index) {
                              if (DataStore.storeData) {
                                DataStore.taxName.add(
                                    snapshot.data!.docs[index]["Tax Name"]);
                                DataStore.taxPercentage.add(snapshot
                                    .data!.docs[index]["Percentage"]
                                    .toString());
                                DataStore.taxPrice.add(((DataStore.totalPrice *
                                            snapshot.data!.docs[index]
                                                ["Percentage"]) /
                                        100)
                                    .toString());
                              }
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(snapshot.data!.docs[index]["Tax Name"]
                                          .toString() +
                                      ".(" +
                                      snapshot.data!.docs[index]["Percentage"]
                                          .toString() +
                                      "%)"),
                                  Text(((DataStore.totalPrice *
                                              snapshot.data!.docs[index]
                                                  ["Percentage"]) /
                                          100)
                                      .toString()),
                                ],
                              );
                            },
                          );
                        }
                      },
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(200, 0, 36, 0),
                      child: Divider(
                        height: 10,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
                          child: Text(
                            "Grand Total :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
                          child: Text(
                            DataStore.grandTotal.toStringAsFixed(2),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// import 'dart:async';
// import 'dart:ui';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:premium_hotels/routes.dart';
// import '../DataBase.dart';

// class Billpage extends StatefulWidget {
//   const Billpage({Key? key}) : super(key: key);

//   @override
//   State<Billpage> createState() => _BillpageState();
// }

// class _BillpageState extends State<Billpage> {
//   @override
//   void initState() {
//     fecthData();
//     // map();
//     super.initState();
//   }

//   map() async {
//     DocumentReference<Map<String, dynamic>> years = FirebaseFirestore.instance
//         .collection("Company")
//         .doc(DataStore.hotelCode)
//         .collection("PL")
//         .doc("Profit")
//         .collection("Year")
//         .doc("2022")
//         .collection("month")
//         .doc("01");
//     // DocumentSnapshot<Map<String, dynamic>> Order = await years.get();
//     // print(Order["Items"]["PBM"]);
//     await years.update({
//       "Items": {"PBM": 30},
//     });
//     // print(Order["Items"]["PBM"]);
//   }

//   fecthData() async {
//     DataStore.itemName = [];
//     DataStore.itemPrice = [];
//     DataStore.itemQutity = [];
//     DataStore.itemTotalPrice = [];
//     DataStore.taxName = [];
//     DataStore.taxPercentage = [];
//     DataStore.taxPrice = [];
//     DataStore.storeData = false;
//     // ignore: non_constant_identifier_names
//     DocumentSnapshot<Map<String, dynamic>> Order = await FirebaseFirestore
//         .instance
//         .collection("Company")
//         .doc(DataStore.hotelCode)
//         .collection("Table")
//         .doc(DataStore.TableNo)
//         .get();
//     DataStore.totalPrice = Order["Total Price"];
//     DataStore.billName = Order["Name"];
//     DataStore.billPhoneNumber = Order["Contact Number"];
//     DataStore.paymentMethod = Order["Payment Method"];
//     DataStore.grandTotal = Order["Grand Total"].toDouble();
//     if (!Order["Price Clcu"]) {
//       Navigator.pushNamed(context, MyRotues.beforeBillRoute).then(onGoBack);
//     }
//     setState(() {
//       DataStore.storeData = true;
//     });
//     String cyear = DateFormat("yyyy").format(DateTime.now());
//     String cmonth = DateFormat("MM").format(DateTime.now());
//     String cday = DateFormat("dd").format(DateTime.now());
//     String ctime = DateFormat("hhmmss").format(DateTime.now());
//     DocumentReference<Map<String, dynamic>> years = FirebaseFirestore.instance
//         .collection("Company")
//         .doc(DataStore.hotelCode)
//         .collection("PL")
//         .doc("Profit")
//         .collection("Year")
//         .doc(cyear);
//     DocumentReference<Map<String, dynamic>> month =
//         years.collection("month").doc(cmonth);
//     DocumentReference<Map<String, dynamic>> days =
//         month.collection("Days").doc(cday);
//     DocumentSnapshot<Map<String, dynamic>> daysData = await days.get();
//     DocumentSnapshot<Map<String, dynamic>> monthData = await days.get();
//     DocumentSnapshot<Map<String, dynamic>> yearData = await days.get();
//     if (yearData.data() == null) {
//       await years.set({
//         "Items": {},
//       });
//     }
//     if (monthData.data() == null) {
//       await month.set({
//         "Items": {},
//       });
//     }
//     if (daysData.data() == null) {
//       await days.set({
//         "Items": {},
//       });
//     }
//   }

//   FutureOr onGoBack(dynamic value) {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Orders',
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 if (DataStore.storeData) {
//                   Navigator.pushNamed(context, MyRotues.printbillRoutecashier);
//                 }
//               },
//               icon: const Icon(Icons.print_rounded))
//         ],
//         backgroundColor: const Color(0xfffe9721),
//         centerTitle: true,
//       ),
//       body: Container(
//         height: MediaQuery.of(context).size.height,
//         padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
//         color: Colors.white,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.end,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
//               child: Container(
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(20),
//                   ),
//                   border: Border(
//                     top: BorderSide(
//                       color: const Color(0xfffe9721),
//                       width: 4,
//                     ),
//                     bottom: BorderSide(
//                       color: const Color(0xfffe9721),
//                       width: 4,
//                     ),
//                     left: BorderSide(
//                       color: const Color(0xfffe9721),
//                       width: 4,
//                     ),
//                     right: BorderSide(
//                       color: const Color(0xfffe9721),
//                       width: 4,
//                     ),
//                   ),
//                 ),
//                 height: MediaQuery.of(context).size.height * 0.800,
//                 child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   stream: FirebaseFirestore.instance
//                       .collection("Company")
//                       .doc(DataStore.hotelCode)
//                       .collection("Table")
//                       .doc(DataStore.TableNo)
//                       .collection("Order")
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (snapshot.hasError) {
//                       return Text(snapshot.error.toString());
//                     } else if (snapshot.data!.size == 0) {
//                       return const Center(
//                           child: Text("Opp Item Is Not Available"));
//                     } else {
//                       //
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.size,
//                         itemBuilder: (context, index) {
//                           if (DataStore.storeData) {
//                             print("Data Added" + index.toString());
//                             DataStore.itemName
//                                 .add(snapshot.data!.docs[index]["Name"]);
//                             DataStore.itemPrice.add(
//                                 snapshot.data!.docs[index]["Price"].toString());
//                             DataStore.itemQutity.add((snapshot.data!.docs[index]
//                                         ["Count"] -
//                                     snapshot.data!.docs[index]["Pending"])
//                                 .toString());
//                             DataStore.itemTotalPrice.add(((snapshot
//                                             .data!.docs[index]["Count"] -
//                                         snapshot.data!.docs[index]["Pending"]) *
//                                     snapshot.data!.docs[index]["Price"])
//                                 .toString());
//                           }
//                           return Padding(
//                             padding: const EdgeInsets.fromLTRB(8, 5, 8, 5),
//                             child: ClipRRect(
//                               borderRadius: const BorderRadius.all(
//                                 Radius.circular(10),
//                                 // topLeft: Radius.circular(30.0),
//                                 // bottomRight: Radius.circular(30.0),
//                               ),
//                               child: BackdropFilter(
//                                 filter: ImageFilter.blur(
//                                   sigmaX: 2.5,
//                                   sigmaY: 2.5,
//                                 ),
//                                 child: Container(
//                                   height: 100,
//                                   width: MediaQuery.of(context).size.width - 5,
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xfffe9721)
//                                         .withOpacity(0.35),
//                                     // color: Colors.black.withOpacity(0.25),
//                                     border: Border.all(
//                                         color: const Color(0xfffe9721),
//                                         width: 1.2),
//                                     borderRadius: const BorderRadius.all(
//                                       Radius.circular(10.0),
//                                       // topLeft: Radius.circular(30.0),
//                                       // bottomRight: Radius.circular(30.0),
//                                     ),
//                                   ),
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(children: [
//                                         const Expanded(
//                                             flex: 3,
//                                             child: Padding(
//                                                 padding: EdgeInsets.fromLTRB(
//                                                     15, 10, 15, 10),
//                                                 child: ClipOval(
//                                                   child: Image(
//                                                       image: AssetImage(
//                                                           "assets/images/applogo.jpg"),
//                                                       fit: BoxFit.cover),
//                                                   //aaaaaaaaaaaaaaa
//                                                   // child: Image(
//                                                   // image: NetworkImage(
//                                                   //     DataStore.item[index]
//                                                   //         ["Image"]),
//                                                 ))),
//                                         Expanded(
//                                           flex: 8,
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.center,
//                                                 children: [
//                                                   Text(
//                                                     snapshot.data!.docs[index]
//                                                         ["Name"],
//                                                     style: const TextStyle(
//                                                         fontSize: 18,
//                                                         letterSpacing: 0.5,
//                                                         fontWeight:
//                                                             FontWeight.bold),
//                                                   ),
//                                                   const SizedBox(
//                                                     width: 20,
//                                                   ),
//                                                 ],
//                                               ),
//                                               Padding(
//                                                 padding:
//                                                     const EdgeInsets.fromLTRB(
//                                                         0, 3, 0, 0),
//                                                 child: Row(
//                                                   mainAxisAlignment:
//                                                       MainAxisAlignment
//                                                           .spaceEvenly,
//                                                   children: [
//                                                     Text(
//                                                       "Qty: ${(snapshot.data!.docs[index]["Count"] - snapshot.data!.docs[index]["Pending"]).toString()}",
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     Text(
//                                                       "Price : " +
//                                                           snapshot
//                                                               .data!
//                                                               .docs[index]
//                                                                   ["Price"]
//                                                               .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               const Padding(
//                                                 padding: EdgeInsets.fromLTRB(
//                                                     130, 2, 40, 2),
//                                                 child: Divider(
//                                                   height: 10,
//                                                   color: Colors.black,
//                                                 ),
//                                               ),
//                                               Row(
//                                                 mainAxisAlignment:
//                                                     MainAxisAlignment.end,
//                                                 children: [
//                                                   Padding(
//                                                     padding: const EdgeInsets
//                                                             .fromLTRB(
//                                                         120, 2, 55, 2),
//                                                     child: Text(
//                                                       "Total: " +
//                                                           ((snapshot.data!.docs[
//                                                                               index]
//                                                                           [
//                                                                           "Count"] -
//                                                                       snapshot.data!
//                                                                               .docs[index]
//                                                                           [
//                                                                           "Pending"]) *
//                                                                   snapshot.data!
//                                                                               .docs[
//                                                                           index]
//                                                                       ["Price"])
//                                                               .toString(),
//                                                       style: const TextStyle(
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                       ])
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   },
//                 ),
//               ),
//             ),

//             //---------------------------------------------------------------------
//             Padding(
//               padding: const EdgeInsets.fromLTRB(4, 7, 4, 10),
//               child: Container(
//                 // height: MediaQuery.of(context).size.height,
//                 decoration: const BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(20),
//                   ),
//                   border: Border(
//                     top: BorderSide(
//                       color: const Color(0xfffe9721),
//                       width: 4,
//                     ),
//                     bottom: BorderSide(
//                       color: const Color(0xfffe9721),
//                       width: 4,
//                     ),
//                     left: BorderSide(
//                       color: const Color(0xfffe9721),
//                       width: 4,
//                     ),
//                     right: BorderSide(
//                       color: const Color(0xfffe9721),
//                       width: 4,
//                     ),
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
//                           child: Text(
//                             "Total : ",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 0, 55, 0),
//                           child: Text(
//                             DataStore.totalPrice.toString(),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                     StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                       stream: FirebaseFirestore.instance
//                           .collection("Company")
//                           .doc(DataStore.hotelCode)
//                           .collection("Tax")
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.connectionState ==
//                             ConnectionState.waiting) {
//                           return const Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         }
//                         if (snapshot.hasError) {
//                           return Text(snapshot.error.toString());
//                         } else if (snapshot.data!.size == 0) {
//                           return const Center(
//                               child: Padding(
//                             padding: EdgeInsets.fromLTRB(166, 0, 0, 0),
//                             child: Text(
//                               "Tax : ",
//                               style: TextStyle(fontWeight: FontWeight.bold),
//                             ),
//                           ));
//                         } else {
//                           return ListView.builder(
//                             shrinkWrap: true,
//                             itemCount: snapshot.data!.size,
//                             itemBuilder: (context, index) {
//                               if (DataStore.storeData) {
//                                 DataStore.taxName.add(
//                                     snapshot.data!.docs[index]["Tax Name"]);
//                                 DataStore.taxPercentage.add(snapshot
//                                     .data!.docs[index]["Percentage"]
//                                     .toString());
//                                 DataStore.taxPrice.add(((DataStore.totalPrice *
//                                             snapshot.data!.docs[index]
//                                                 ["Percentage"]) /
//                                         100)
//                                     .toString());
//                               }
//                               return Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(snapshot.data!.docs[index]["Tax Name"]
//                                           .toString() +
//                                       ".(" +
//                                       snapshot.data!.docs[index]["Percentage"]
//                                           .toString() +
//                                       "%)"),
//                                   Text(((DataStore.totalPrice *
//                                               snapshot.data!.docs[index]
//                                                   ["Percentage"]) /
//                                           100)
//                                       .toString()),
//                                 ],
//                               );
//                             },
//                           );
//                         }
//                       },
//                     ),
//                     const Padding(
//                       padding: EdgeInsets.fromLTRB(200, 0, 36, 0),
//                       child: Divider(
//                         height: 10,
//                         color: Colors.black,
//                       ),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.fromLTRB(120, 0, 0, 0),
//                           child: Text(
//                             "Grand Total :",
//                             style: TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.fromLTRB(0, 0, 35, 0),
//                           child: Text(
//                             DataStore.grandTotal.toStringAsFixed(2),
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:premium_hotels/routes.dart';
// import '../DataBase.dart';

// class Billpage extends StatefulWidget {
//   const Billpage({Key? key}) : super(key: key);

//   @override
//   State<Billpage> createState() => _BillpageState();
// }

// class _BillpageState extends State<Billpage> {
//   @override
//   void initState() {
//     fecthData();
//     // map();
//     super.initState();
//   }

//   map() async {
//     DocumentReference<Map<String, dynamic>> years = FirebaseFirestore.instance
//         .collection("Company")
//         .doc(DataStore.hotelCode)
//         .collection("PL")
//         .doc("Profit")
//         .collection("Year")
//         .doc("2022")
//         .collection("month")
//         .doc("01");
//     // DocumentSnapshot<Map<String, dynamic>> Order = await years.get();
//     // print(Order["Items"]["PBM"]);
//     await years.update({
//       "Items": {"PBM": 30},
//     });
//     // print(Order["Items"]["PBM"]);
//   }

//   fecthData() async {
//     DataStore.itemName = [];
//     DataStore.itemPrice = [];
//     DataStore.itemQutity = [];
//     DataStore.itemTotalPrice = [];
//     DataStore.taxName = [];
//     DataStore.taxPercentage = [];
//     DataStore.taxPrice = [];
//     DataStore.storeData = false;
//     // ignore: non_constant_identifier_names
//     DocumentSnapshot<Map<String, dynamic>> Order = await FirebaseFirestore
//         .instance
//         .collection("Company")
//         .doc(DataStore.hotelCode)
//         .collection("Table")
//         .doc(DataStore.TableNo)
//         .get();
//     DataStore.totalPrice = Order["Total Price"];
//     DataStore.billName = Order["Name"];
//     DataStore.billPhoneNumber = Order["Contact Number"];
//     DataStore.paymentMethod = Order["Payment Method"];
//     DataStore.grandTotal = Order["Grand Total"].toDouble();
//     if (!Order["Price Clcu"]) {
//       Navigator.pushNamed(context, MyRotues.beforeBillRoute).then(onGoBack);
//     }
//     setState(() {
//       DataStore.storeData = true;
//     });
//     String cyear = DateFormat("yyyy").format(DateTime.now());
//     String cmonth = DateFormat("MM").format(DateTime.now());
//     String cday = DateFormat("dd").format(DateTime.now());
//     String ctime = DateFormat("hhmmss").format(DateTime.now());
//     DocumentReference<Map<String, dynamic>> years = FirebaseFirestore.instance
//         .collection("Company")
//         .doc(DataStore.hotelCode)
//         .collection("PL")
//         .doc("Profit")
//         .collection("Year")
//         .doc(cyear);
//     DocumentReference<Map<String, dynamic>> month =
//         years.collection("month").doc(cmonth);
//     DocumentReference<Map<String, dynamic>> days =
//         month.collection("Days").doc(cday);
//     DocumentSnapshot<Map<String, dynamic>> daysData = await days.get();
//     DocumentSnapshot<Map<String, dynamic>> monthData = await days.get();
//     DocumentSnapshot<Map<String, dynamic>> yearData = await days.get();
//     if (yearData.data() == null) {
//       await years.set({
//         "Items": {},
//       });
//     }
//     if (monthData.data() == null) {
//       await month.set({
//         "Items": {},
//       });
//     }
//     if (daysData.data() == null) {
//       await days.set({
//         "Items": {},
//       });
//     }
//   }

//   FutureOr onGoBack(dynamic value) {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Orders',
//         ),
//         backgroundColor: Colors.cyan,
//         centerTitle: true,
//       ),
//       body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//           Widget>[
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Bill",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Name: ${DataStore.billName}",
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Contact Number: ${DataStore.billPhoneNumber}",
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Payment Method: ${DataStore.paymentMethod}",
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Total Price: ${DataStore.totalPrice}",
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Grand Total: ${DataStore.grandTotal}",
//             style: TextStyle(
//               fontSize: 20,
//             ),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text(
//             "Items",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//         Expanded(
//           child: ListView.builder(
//             itemCount: DataStore.itemName.length,
//             itemBuilder: (BuildContext context, int index) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: <Widget>[
//                     Text(
//                       "${DataStore.itemName[index]}",
//                       style: TextStyle(
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       " ${DataStore.itemPrice[index]}",
//                       style: TextStyle(
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       " ${DataStore.itemQutity[index]}",
//                       style: TextStyle(
//                         fontSize: 20,
//                       ),
//                     ),
//                     Text(
//                       " ${DataStore.itemTotalPrice[index]}",
//                       style: TextStyle(
//                         fontSize: 20,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//               children:
//               [
//                 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   stream: FirebaseFirestore.instance
//                       .collection("Company")
//                       .doc(DataStore.hotelCode)
//                       .collection("Table")
//                       .doc(DataStore.TableNo)
//                       .collection("Order")
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (snapshot.hasError) {
//                       return Text(snapshot.error.toString());
//                     } else if (snapshot.data!.size == 0) {
//                       return const Center(
//                           child: Text("Opp Item Is Not Available"));
//                     } else {
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.size,
//                         itemBuilder: (context, index) {
//                           if (DataStore.storeData) {
//                             print("Data Added" + index.toString());
//                             DataStore.itemName
//                                 .add(snapshot.data!.docs[index]["Name"]);
//                             DataStore.itemPrice.add(
//                                 snapshot.data!.docs[index]["Price"].toString());
//                             DataStore.itemQutity.add((snapshot.data!.docs[index]
//                                         ["Count"] -
//                                     snapshot.data!.docs[index]["Pending"])
//                                 .toString());
//                             DataStore.itemTotalPrice.add(((snapshot
//                                             .data!.docs[index]["Count"] -
//                                         snapshot.data!.docs[index]["Pending"]) *
//                                     snapshot.data!.docs[index]["Price"])
//                                 .toString());
//                           }
//                           return Container(
//                             padding: const EdgeInsets.all(10),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Text(
//                                       snapshot.data!.docs[index]["Name"],
//                                       style: const TextStyle(
//                                         fontSize: 20,
//                                       ),
//                                     ),
//                                     const SizedBox(
//                                       width: 20,
//                                     ),
//                                   ],
//                                 ),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                         "Qty: ${(snapshot.data!.docs[index]["Count"] - snapshot.data!.docs[index]["Pending"]).toString()}"),
//                                     const Spacer(),
//                                     Text("Rs : " +
//                                         snapshot.data!.docs[index]["Price"]
//                                             .toString()),
//                                     const Spacer(),
//                                     Text("Total: " +
//                                         ((snapshot.data!.docs[index]["Count"] -
//                                                     snapshot.data!.docs[index]
//                                                         ["Pending"]) *
//                                                 snapshot.data!.docs[index]
//                                                     ["Price"])
//                                             .toString())
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     }
//                   },
//                 ),
//                 const Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Total"),
//                     Text(DataStore.totalPrice.toString()),
//                   ],
//                 ),
//                 StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                   stream: FirebaseFirestore.instance
//                       .collection("Company")
//                       .doc(DataStore.hotelCode)
//                       .collection("Tax")
//                       .snapshots(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting) {
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     }
//                     if (snapshot.hasError) {
//                       return Text(snapshot.error.toString());
//                     } else if (snapshot.data!.size == 0) {
//                       return const Center(
//                           child: Text("Opp Item Is Not Available"));
//                     } else {
//                       return ListView.builder(
//                         shrinkWrap: true,
//                         itemCount: snapshot.data!.size,
//                         itemBuilder: (context, index) {
//                           if (DataStore.storeData) {
//                             DataStore.taxName
//                                 .add(snapshot.data!.docs[index]["Tax Name"]);
//                             DataStore.taxPercentage.add(snapshot
//                                 .data!.docs[index]["Percentage"]
//                                 .toString());
//                             DataStore.taxPrice.add(((DataStore.totalPrice *
//                                         snapshot.data!.docs[index]
//                                             ["Percentage"]) /
//                                     100)
//                                 .toString());
//                           }
//                           return Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(snapshot.data!.docs[index]["Tax Name"]
//                                       .toString() +
//                                   ".(" +
//                                   snapshot.data!.docs[index]["Percentage"]
//                                       .toString() +
//                                   "%)"),
//                               Text(((DataStore.totalPrice *
//                                           snapshot.data!.docs[index]
//                                               ["Percentage"]) /
//                                       100)
//                                   .toString()),
//                             ],
//                           );
//                         },
//                       );
//                     }
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text("Grand Total"),
//                     Text(DataStore.grandTotal.toStringAsFixed(2)),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 50,
//                   child: IconButton(
//                       onPressed: () {
//                         if (DataStore.storeData) {
//                           Navigator.pushNamed(
//                               context, MyRotues.printbillRoutecashier);
//                         }
//                       },
//                       icon: const Icon(Icons.print_rounded)),
//                 )
//               ];
//             },
//           ),
//         ),
//       ]),
//     );
//   }
// }
