import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChefDrawer extends StatefulWidget {
  const ChefDrawer({Key? key}) : super(key: key);

  @override
  State<ChefDrawer> createState() => _DrawerState();
}

class _DrawerState extends State<ChefDrawer> {
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
                          child: Text('Chef'),
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

                        
                        //My Profile
                        ListTile(
                          onTap: () {
                            HapticFeedback.vibrate();
                            //j koi pan chef hoy teni profile ma navigator.puch kari devu
                          },
                          leading: const Icon(
                            CupertinoIcons.profile_circled,
                            color: Colors.black,
                          ),
                          title: const Text(
                            "My Profile",
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


