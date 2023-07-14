import 'package:flutter/material.dart';
import 'package:premium_hotels/Waiter/choosetablew.dart';
import 'package:premium_hotels/Waiter/pendingdelivery.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class Waiter extends StatefulWidget {
  const Waiter({Key? key}) : super(key: key);

  @override
  State<Waiter> createState() => _WaiterState();
}

class _WaiterState extends State<Waiter> {
  int _currentIndex = 1;
  final Screen = [
    ChooseTableW(),
    PendingDeliveryW(),
    // OrderPageW(),
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.cyan,
      child: SafeArea(
        top: false,
        child: Scaffold(
          extendBody: true,
          bottomNavigationBar: CurvedNavigationBar(
            color: Colors.cyan,
            backgroundColor: Colors.transparent,
            // animationCurve: Curves.elasticInOut,
            height: 60,
            index: _currentIndex,
            animationDuration: Duration(milliseconds: 600),
            items: const <Widget>[
              Icon(
                Icons.filter_list,
                size: 30,
                color: Colors.white,
              ),
              Icon(
                Icons.home_work_outlined,
                size: 35,
                color: Colors.white,
              ),
              // Icon(
              //   Icons.show_chart,
              //   size: 30,
              //   color: Colors.white,
              // ),
            ],
            onTap: (index) {
              //Handle button tap
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          body: IndexedStack(
            children: Screen,
            index: _currentIndex,
          ),
        ),
      ),
    );
  }
}
