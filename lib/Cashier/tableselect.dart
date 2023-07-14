import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class Tableselectcashier extends StatefulWidget {
  const Tableselectcashier({Key? key}) : super(key: key);

  @override
  State<Tableselectcashier> createState() => _TableselectcashierState();
}

class _TableselectcashierState extends State<Tableselectcashier> {
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
        backgroundColor: const Color(0xfffe9721),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                return GridView.builder(
                  scrollDirection: Axis.vertical,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 7.50,
                      mainAxisSpacing: 7.50),
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    Color tablecolor;
                    if (snapshot.data!.docs[index]["Status"] == "Free") {
                      tablecolor = Colors.green;
                    } else {
                      //This For Occupied Table
                      tablecolor = Colors.red;
                    }
                    return Container(
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                        gradient: const LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            Colors.yellow,
                            Colors.orange,
                            Colors.red,
                          ],
                        ),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                              offset: Offset(2.0, 2.0))
                        ],
                      ),
                      child: GestureDetector(
                        // onTap: () {
                        //   // if (snapshot.data!.docs[index]["Status"] == "Free") {
                        //     Navigator.pushNamed(context, MyRotues.itempagewRoute);
                        //     DataStore.TableNo =
                        //         snapshot.data!.docs[index]["Table Number"].toString();
                        //   // }
                        // },
                        onTap: () {
                          Navigator.pushNamed(
                              context, MyRotues.billRoutecashier);
                          DataStore.TableNo = snapshot
                              .data!.docs[index]["Table Number"]
                              .toString();
                        },
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  snapshot.data!.docs[index]["Table Capacity"]
                                      .toString(),
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold),
                                ),
                                Icon(
                                  Icons.eco_rounded,
                                  color: tablecolor,
                                ),
                              ],
                            ),
                            const Expanded(
                              flex: 2,
                              child: Image(
                                  image: AssetImage(
                                      "assets/images/tablelogo.png")),
                            ),
                            Expanded(
                              child: Text(
                                snapshot.data!.docs[index]["Table Number"]
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
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
    );
  }
}



// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:premium_hotels/DataBase.dart';
// import 'package:premium_hotels/routes.dart';

// class Tableselectcashier extends StatefulWidget {
//   const Tableselectcashier({Key? key}) : super(key: key);

//   @override
//   State<Tableselectcashier> createState() => _TableselectcashierState();
// }

// class _TableselectcashierState extends State<Tableselectcashier> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Table',
//         ),
//         backgroundColor: const Color(0xfffe9721),
//         centerTitle: true,
//       ),
//       body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         stream: FirebaseFirestore.instance
//             .collection("Company")
//             .doc(DataStore.hotelCode)
//             .collection("Table")
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Text(snapshot.error.toString());
//           } else if (snapshot.data!.size == 0) {
//             return const Center(child: Text("Opp No Table is Created"));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.size,
//               itemBuilder: (context, index) {
//                 Color tablecolor;
//                 if (snapshot.data!.docs[index]["Status"] == "Free") {
//                   tablecolor = Colors.green;
//                 } else {
//                   //This For Occupied Table
//                   tablecolor = Colors.red;
//                 }
//                 return Container(
//                   height: 100,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                       color: Colors.black,
//                       width: 2.0,
//                     ),
//                     borderRadius: BorderRadius.circular(10.0),
//                     gradient: const LinearGradient(
//                       begin: Alignment.topRight,
//                       end: Alignment.bottomLeft,
//                       colors: [
//                         Colors.orange,
//                         Colors.yellow,
//                       ],
//                     ),
//                     boxShadow: const [
//                       BoxShadow(
//                           color: Colors.grey,
//                           blurRadius: 2.0,
//                           offset: Offset(2.0, 2.0))
//                     ],
//                   ),
//                   child: GestureDetector(
//                     // onTap: () {
//                     //   // if (snapshot.data!.docs[index]["Status"] == "Free") {
//                     //     Navigator.pushNamed(context, MyRotues.itempagewRoute);
//                     //     DataStore.TableNo =
//                     //         snapshot.data!.docs[index]["Table Number"].toString();
//                     //   // }
//                     // },
//                     onTap: () {
//                       Navigator.pushNamed(context, MyRotues.billRoutecashier);
//                       DataStore.TableNo =
//                           snapshot.data!.docs[index]["Table Number"].toString();
//                     },

//                     child: ListTile(
//                       title: Text(
//                           "TABLE : " +
//                               snapshot.data!.docs[index]["Table Number"]
//                                   .toString(),
//                           style: TextStyle(
//                               fontSize: 20,
//                               color: tablecolor,
//                               fontWeight: FontWeight.bold)),
//                       trailing: Text(
//                         "Capacity : " +
//                             snapshot.data!.docs[index]["Table Capacity"]
//                                 .toString(),
//                         style: const TextStyle(fontSize: 16),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

