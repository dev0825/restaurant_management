import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DataStore {
  //Boss
  static bool isImageSelected = false;

  //Data Coming Form Firebase Of Profile
  static List profile = [];
  static Future fetchListProfile() async {
    QuerySnapshot<Map<String, dynamic>> data;
    data = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Profile")
        .get();
    profile = [];
    for (var i = 0; i < data.size; i++) {
      profile.add(data.docs[i]);
    }
    return data;
  }

  //Data Coming Form Firebase Of Electricty
  static String cyear = DateFormat("yyyy").format(DateTime.now());
  static List electrictyDate = [];
  static List electrictypayStatus = [];
  static List electrictybill = [];
  static Future fetchElectricty() async {
    DocumentSnapshot<Map<String, dynamic>> data;
    data = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("PL")
        .doc("Loss")
        .collection("Electricty")
        .doc(cyear)
        .get();
    if (!data.exists) {
      await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("PL")
          .doc("Loss")
          .collection("Electricty")
          .doc(cyear)
          .set({
        "Date": ["", "", "", "", "", "", "", "", "", "", "", ""],
        "payStatus": [
          "Pending",
          "Pending",
          "Pending",
          "Pending",
          "Pending",
          "Pending",
          "Pending",
          "Pending",
          "Pending",
          "Pending",
          "Pending",
          "Pending"
        ],
        "Bill": [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
      });
      yearListElectricty.add(cyear);
      await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("PL")
          .doc("Loss")
          .update({
        "ElectrictyYear": yearListElectricty,
      });
      data = await FirebaseFirestore.instance
          .collection("Company")
          .doc(DataStore.hotelCode)
          .collection("PL")
          .doc("Loss")
          .collection("Electricty")
          .doc(cyear)
          .get();
    }
    electrictyDate = [];
    electrictypayStatus = [];
    electrictybill = [];
    electrictyDate = data["Date"];
    electrictypayStatus = data["payStatus"];
    electrictybill = data["Bill"];
    return data;
  }

  //Data Coming Form Firebase Of Category
  static List category = [];
  static List<int> selectionOfCategory = [];
  static Future fetchListCategory() async {
    QuerySnapshot<Map<String, dynamic>> data;
    data = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Category")
        .get();
    category = [];
    for (var i = 0; i < data.size; i++) {
      category.add(data.docs[i]);
      selectionOfCategory.add(0);
    }
    return data;
  }

  //Data Coming Form Firebase Of ExpenseCategory
  static List expenseCategory = [];
  static List expenseCategoryUrl = [];
  static List yearListElectricty = [];
  static Future fetchListExpenseCategory() async {
    DocumentSnapshot<Map<String, dynamic>> data;
    data = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("PL")
        .doc("Loss")
        .get();
    expenseCategory = [];
    expenseCategoryUrl = [];
    yearListElectricty = [];
    expenseCategory = data["Category"];
    expenseCategoryUrl = data["CategoryUrl"];
    yearListElectricty = data["ElectrictyYear"];
    return data;
  }

  //Data Coming Form Firebase Of Item
  static List item = [];
  static Future fetchListItem() async {
    QuerySnapshot<Map<String, dynamic>> data;
    data = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Item")
        .get();
    item = [];
    for (var i = 0; i < data.size; i++) {
      item.add(data.docs[i]);
    }
    return data;
  }

  //Data Coming Form Firebase Of Table
  // ignore: non_constant_identifier_names
  static List Table = [];
  static Future fetchListTable() async {
    QuerySnapshot<Map<String, dynamic>> data;
    // data = await FirebaseFirestore.instance.collection("dummy").doc("Table").collection("Table").get();
    data = await FirebaseFirestore.instance
        .collection("Company")
        .doc(DataStore.hotelCode)
        .collection("Table")
        .get();
    Table = [];
    for (var i = 0; i < data.size; i++) {
      Table.add(data.docs[i]);
    }
    return data;
  }

  //Waiter
  // ignore: non_constant_identifier_names
  static String TableNo = "";
  //Manager
  static List itemName = [];
  static List itemQutity = [];
  static List itemPrice = [];
  static List itemTotalPrice = [];
  static List taxName = [];
  static List taxPercentage = [];
  static List taxPrice = [];
  static bool storeData = false;

  //Chef
  static List chefCategory = [];
  //Genral
  static bool addExpanseCategory = false;
  static String hotelCode = "";
  static String uid = "";
  static int totalPrice = 0;
  static String billName = "";
  static String billPhoneNumber = "";
  static String paymentMethod = "";
  static double grandTotal = 0;
}
