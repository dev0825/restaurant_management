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
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
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
      appBar: AppBar(
        title: const Text("Hotel"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _email,
            decoration: const InputDecoration(
              labelText: "User Name",
              hintText: "Mala4217",
            ),
          ),
          TextFormField(
            obscureText: true,
            controller: _password,
            decoration: const InputDecoration(
              labelText: "Password",
              hintText: "xxxxxx",
            ),
          ),
          ElevatedButton(
              onPressed: () {
                signup();
              },
              child: const Text("sign In")),
          ElevatedButton(
              onPressed: () {
                _email.text = "01bapu";
                _password.text = "123456";
                signup();
              },
              child: const Text("Owner")),
          ElevatedButton(
              onPressed: () {
                _email.text = "01raju";
                _password.text = "123456";
                signup();
              },
              child: const Text("Manager")),
          ElevatedButton(
              onPressed: () {
                _email.text = "01mala";
                _password.text = "123456";
                signup();
              },
              child: const Text("Chef")),
          ElevatedButton(
              onPressed: () {
                _email.text = "01yash";
                _password.text = "123456";
                signup();
              },
              child: const Text("Waiter")),
        ],
      ),
    );
  }
}
