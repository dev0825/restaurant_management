import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:premium_hotels/routes.dart';

class BossDrawer extends StatefulWidget {
  const BossDrawer({Key? key}) : super(key: key);

  @override
  State<BossDrawer> createState() => _DrawerState();
}

class _DrawerState extends State<BossDrawer> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25.0),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.70,
          height: MediaQuery.of(context).size.height * 0.90,
          child: Drawer(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // image: const DecorationImage(
                // image: AssetImage('assets/images/colorful.jpg'),
                // fit: BoxFit.cover,
                // ),
                color: Colors.white.withOpacity(0.99),
                border: Border.all(color: Colors.black45, width: 4.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/logo.png',
                            ),
                          ),
                        ),
                        const Center(
                          child: Text('name'),
                        ),
                        const Center(
                          child: Text('Designation'),
                        ),

                        // --------------------Divider----------------------
                        const Divider(
                          color: Colors.black,
                          thickness: 2,
                          indent: 55,
                          endIndent: 55,
                        ),

                        //Expense
                        ListTile(
                          onTap: () {
                            HapticFeedback.vibrate();
                            Navigator.pushNamed(
                                context, MyRotues.expenseRoute);
                          },
                          leading: const Icon(
                            CupertinoIcons.building_2_fill,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Expense",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          indent: 10,
                          endIndent: 95,
                        ),
                        //Category
                        ListTile(
                          onTap: () {
                            HapticFeedback.vibrate();
                            Navigator.pushNamed(
                                context, MyRotues.viewcategoryRoute);
                          },
                          leading: const Icon(
                            CupertinoIcons.cart_fill_badge_plus,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Categoty",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          indent: 10,
                          endIndent: 95,
                        ),
                        //Item
                        ListTile(
                          onTap: () {
                            HapticFeedback.vibrate();
                            Navigator.pushNamed(
                                context, MyRotues.viewitemRoute);
                          },
                          leading: const Icon(
                            CupertinoIcons.infinite,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Item",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          indent: 10,
                          endIndent: 95,
                        ),
                        //Employee
                        ListTile(
                          onTap: () {
                            HapticFeedback.vibrate();
                            Navigator.pushNamed(
                                context, MyRotues.viewemployeeRoute);
                          },
                          leading: const Icon(
                            CupertinoIcons.money_dollar_circle,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Employee",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          indent: 10,
                          endIndent: 95,
                        ),

                        //Table
                        ListTile(
                          onTap: () {
                            HapticFeedback.vibrate();
                            Navigator.pushNamed(
                                context, MyRotues.viewtableRoute);
                          },
                          leading: const Icon(
                            CupertinoIcons.desktopcomputer,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Table",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          indent: 10,
                          endIndent: 95,
                        ),
                        //Setting
                        ListTile(
                          onTap: () {
                            HapticFeedback.vibrate();
                            Navigator.pushNamed(context, MyRotues.settingRoute);
                          },
                          leading: const Icon(
                            CupertinoIcons.settings_solid,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "Setting",
                            textScaleFactor: 1.5,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          indent: 10,
                          endIndent: 95,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




                    //     //Stock
                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: const ListTile(
                    //         leading: Icon(Icons.ac_unit),
                    //         title: Text('Stock'),
                    //       ),
                    //     ),
                    //     //Category ma jase
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.pushNamed(
                    //             context, MyRotues.viewcategoryRoute);
                    //       },
                    //       child: const ListTile(
                    //         leading: Icon(Icons.ac_unit),
                    //         title: Text('Category'),
                    //       ),
                    //     ),
                    //     //Item ma jase
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.pushNamed(
                    //             context, MyRotues.viewitemRoute);
                    //       },
                    //       child: const ListTile(
                    //         leading: Icon(Icons.ac_unit),
                    //         title: Text('Item'),
                    //       ),
                    //     ),
                    //     //Employee ma jase
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.pushNamed(
                    //             context, MyRotues.viewemployeeRoute);
                    //       },
                    //       child: const ListTile(
                    //         leading: Icon(Icons.ac_unit),
                    //         title: Text('Employee'),
                    //       ),
                    //     ),
                    //     //Table ma jase
                    //     GestureDetector(
                    //       onTap: () {
                    //         Navigator.pushNamed(
                    //             context, MyRotues.viewtableRoute);
                    //       },
                    //       child: const ListTile(
                    //         leading: Icon(Icons.ac_unit),
                    //         title: Text('Table'),
                    //       ),
                    //     ),

                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: const ListTile(
                    //         leading: Icon(Icons.ac_unit),
                    //         title: Text('Setting'),
                    //       ),
                    //     ),
                    //   ],
                  