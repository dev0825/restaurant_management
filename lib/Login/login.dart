import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:premium_hotels/DataBase.dart';
import 'package:premium_hotels/routes.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  void signup() async {
    try {
      // Sign Up
      // await FirebaseAuth.instance.createUserWithEmailAndPassword(
      //     email: "malav@malav.wt.cm", password: "1234567");
      // var uid = FirebaseAuth.instance.currentUser!.uid.characters;
      // await FirebaseFirestore.instance.collection("Profile").doc(uid.toString()).set({
      //   "Position":"malav is good",
      // });

      //sign in
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text + "@gmail.com", password: _password.text);
      var uid = FirebaseAuth.instance.currentUser!.uid.characters;
      DataStore.uid = uid.toString();
      DataStore.hotelCode = _email.text[0] + _email.text[1];
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("Profile")
          .doc(DataStore.uid)
          .get();
      print("\nData : ");
      print(data["Position"]);
      switch (data["Position"]) {
        case "Owner":
          Navigator.pushReplacementNamed(context, MyRotues.reportpageRoute);
          break;
        case "Chef":
          DataStore.chefCategory = data["Category"];
          Navigator.pushReplacementNamed(context, MyRotues.foodmakingRoute);
          // Navigator.pushNamed(context, MyRotues.foodmakingRoute);
          break;
        case "Manager":
          Navigator.pushReplacementNamed(context, MyRotues.tableRoutecashier);
          // Navigator.pushNamed(context, MyRotues.tableRoutecashier);
          break;
        case "Waiter":
          Navigator.pushReplacementNamed(context, MyRotues.waiterRoute);
          break;
        default:
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Hotel"),
      // ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/loginpage/food0.jpg'),
                  fit: BoxFit.cover),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Color(0xff161d27).withOpacity(0.9),
                  Color(0xff161d27),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  "Welcome!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Time to get started, let's SignIn",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child:
                      // ------
                      TextField(
                    onChanged: (value) {
                      _email.text = value;
                    },
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "User Name",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: const Color(0xff161d27),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xfffe9721))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xfffe9721))),
                    ),
                  ),
                  // -----
                ),
                const SizedBox(height: 12),
                Container(
                  height: 60,
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child: TextField(
                    onChanged: (value) {
                      _password.text = value;
                    },
                    obscureText: true,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(color: Colors.grey.shade700),
                      filled: true,
                      fillColor: const Color(0xff161d27),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xfffe9721))),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide:
                              const BorderSide(color: Color(0xfffe9721))),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Forgot Password",
                  style: TextStyle(
                      color: Color(0xfffe9721),
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 50,
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 40, right: 40),
                  child: RaisedButton(
                    onPressed: () {
                      signup();
                    },
                    color: const Color(0xfffe9721),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      "SIGN IN",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        //Aama website ni link aapvani chhe
                        "SignUp",
                        style: TextStyle(
                            color: Color(0xfffe9721),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:premium_hotels/DataBase.dart';
// import 'package:premium_hotels/routes.dart';

// class Login extends StatefulWidget {
//   Login({Key? key}) : super(key: key);

//   @override
//   _LoginState createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   TextEditingController _email = TextEditingController();
//   TextEditingController _password = TextEditingController();
//   void signup() async {
//     try {
//       // Sign Up
//       // await FirebaseAuth.instance.createUserWithEmailAndPassword(
//       //     email: "malav@malav.wt.cm", password: "1234567");
//       // var uid = FirebaseAuth.instance.currentUser!.uid.characters;
//       // await FirebaseFirestore.instance.collection("Profile").doc(uid.toString()).set({
//       //   "Position":"malav is good",
//       // });

//       //sign in
//       await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: _email.text + "@gmail.com", password: _password.text);
//       var uid = FirebaseAuth.instance.currentUser!.uid.characters;
//       DataStore.uid = uid.toString();
//       DataStore.hotelCode = _email.text[0] + _email.text[1];
//       DocumentSnapshot data = await FirebaseFirestore.instance
//           .collection("Company")
//           .doc(DataStore.hotelCode)
//           .collection("Profile")
//           .doc(DataStore.uid)
//           .get();
//       print("\nData : ");
//       print(data["Position"]);
//       switch (data["Position"]) {
//         case "Owner":
//           Navigator.pushReplacementNamed(context, MyRotues.reportpageRoute);
//           break;
//         case "Chef":
//           DataStore.chefCategory = data["Category"];
//           Navigator.pushReplacementNamed(context, MyRotues.foodmakingRoute);
//           // Navigator.pushNamed(context, MyRotues.foodmakingRoute);
//           break;
//         case "Manager":
//           Navigator.pushReplacementNamed(context, MyRotues.tableRoutecashier);
//           // Navigator.pushNamed(context, MyRotues.tableRoutecashier);
//           break;
//         case "Waiter":
//           Navigator.pushReplacementNamed(context, MyRotues.waiterRoute);
//           break;
//         default:
//       }
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Hotel"),
//       ),
//       body: Column(
//         children: [
//           TextFormField(
//             controller: _email,
//             decoration: const InputDecoration(
//               labelText: "User Name",
//               hintText: "Mala4217",
//             ),
//           ),
//           TextFormField(
//             obscureText: true,
//             controller: _password,
//             decoration: const InputDecoration(
//               labelText: "Password",
//               hintText: "xxxxxx",
//             ),
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 signup();
//               },
//               child: const Text("sign In")),
//           ElevatedButton(
//               onPressed: () {
//                 _email.text = "01bapu";
//                 _password.text = "123456";
//                 signup();
//               },
//               child: const Text("Owner")),
//           ElevatedButton(
//               onPressed: () {
//                 _email.text = "01raju";
//                 _password.text = "123456";
//                 signup();
//               },
//               child: const Text("Manager")),
//           ElevatedButton(
//               onPressed: () {
//                 _email.text = "01mala";
//                 _password.text = "123456";
//                 signup();
//               },
//               child: const Text("Chef")),
//           ElevatedButton(
//               onPressed: () {
//                 _email.text = "01yash";
//                 _password.text = "123456";
//                 signup();
//               },
//               child: const Text("Waiter")),
//         ],
//       ),
//     );
//   }
// }