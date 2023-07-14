import 'package:flutter/material.dart';

import 'drawerboss.dart';

class Reportpage extends StatelessWidget {
  const Reportpage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        title: const Text(
          'Report',
        ),
        backgroundColor: Colors.cyan,
      ),
      drawer: const BossDrawer(),
      body: const Center(
        child: Text(
          'Report',
          style: TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:premium_hotels/drawerpages/bossdrawer.dart';
// import 'package:premium_hotels/utils/routes.dart';

// class Reportpage extends StatelessWidget {
//   const Reportpage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       extendBody: true,
//       appBar: AppBar(),
//       //upar nu drawer
//       drawer: const BossDrawer(),
//       bottomNavigationBar: BottomAppBar(
//         elevation: 15,
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 12.0,
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(
//                 Icons.filter_list,
//               ),
//               onPressed: () {
//                 Navigator.pushNamed(context, MyRotues.addpageRoute);
//               },
//             ),
//             const SizedBox(width: 48.0),
//             IconButton(
//               icon: const Icon(
//                 Icons.show_chart,
//               ),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         child: const Icon(
//           Icons.add_circle_outline_outlined,
//           size: 35,
//         ),
//         onPressed: () {},
//       ),
//       body: const Center(
//         child: Text(
//           'Star Hotels',
//           style: TextStyle(
//             fontSize: 40,
//           ),
//         ),
//       ),
//     );
//   }
// }