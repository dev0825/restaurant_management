import 'Waiter/itempagew.dart';
import 'Waiter/orderpagew.dart';
import 'Waiter/choosetablew.dart';
import 'Boss/pages/reportpage.dart';
import 'Waiter/givenorderpagew.dart';
import 'Waiter/pendingdelivery.dart';
import 'package:flutter/material.dart';
import 'Boss/Drawer/item/additem.dart';
import 'Boss/Drawer/item/viewitem.dart';
import 'Boss/Drawer/table/addtable.dart';
import 'package:premium_hotels/routes.dart';
import 'Boss/Drawer/employee/addemployee.dart';
import 'Boss/Drawer/employee/viewemployee.dart';
import 'package:premium_hotels/Login/login.dart';
import 'package:premium_hotels/Cashier/bill.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:premium_hotels/Waiter/Waiter.dart';
import 'package:premium_hotels/Chef/foodmaking.dart';
import 'package:premium_hotels/Cashier/printBill.dart';
import 'package:premium_hotels/Waiter/BeforeBill.dart';
import 'package:premium_hotels/Cashier/tableselect.dart';
import 'package:premium_hotels/SuperAdmin/superAdmin.dart';
import 'package:premium_hotels/Boss/Drawer/table/viewtable.dart';
import 'package:premium_hotels/Boss/Drawer/employee/exemployee.dart';
import 'package:premium_hotels/Boss/Drawer/Category/addcategory.dart';
import 'package:premium_hotels/Boss/Drawer/Category/viewcategory.dart';
import 'package:premium_hotels/Boss/Drawer/Expense/SalrayExpense.dart';
import 'package:premium_hotels/Boss/Drawer/Expense/categoryExpense.dart';
import 'package:premium_hotels/Boss/Drawer/Expense/electrictyExpense.dart';

// ----------------------------------------------------------------------------
//                     01bapu(owner)       Password:123456
// ----------------------------------------------------------------------------
//                     01mala (waiter)    Password:123456
// ----------------------------------------------------------------------------
//                     01yash(chef)       Password:123456
// ----------------------------------------------------------------------------
//                     01raju(manager)    Password:123456
// ----------------------------------------------------------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HotelApp());
}

class HotelApp extends StatelessWidget {
  const HotelApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      //for ...Login initial page
      initialRoute: MyRotues.loginRoute,

      routes: {
        //...................Login..................
        MyRotues.loginRoute: (context) => Login(),

        //...................Super Admin..................
        MyRotues.superAdminRoute: (context) => const super_admin(),

        //...................Boss...............................

        // MyRotues.settingRoute: (context) =>  Settings(),

        MyRotues.addtableRoute: (context) => Addtable(),
        MyRotues.additemRoute: (context) => const Additem(),
        MyRotues.viewitemRoute: (context) => const Viewitem(),
        MyRotues.viewtableRoute: (context) => const ViewTable(),
        MyRotues.reportpageRoute: (context) => const Reportpage(),
        MyRotues.exEmployeeRoute: (context) => const Exemployee(),
        MyRotues.expenseRoute: (context) => const CategoryExpense(),
        MyRotues.addemployeeRoute: (context) => const Addemployee(),
        MyRotues.addcategoryRoute: (context) => const Addcategory(),
        MyRotues.viewcategoryRoute: (context) => const Viewcategory(),
        MyRotues.viewemployeeRoute: (context) => const Viewemployee(),
        MyRotues.expenseSalrayRoute: (context) => const SalrayExpense(),
        MyRotues.expenseElectricityRoute: (context) =>
            const ElectrictyExpense(),
        // MyRotues.expenseRoute: (context) => const ExpensePage(),

        //....................Waiter............................
        MyRotues.waiterRoute: (context) => const Waiter(),
        MyRotues.beforeBillRoute: (context) => BeforeBill(),
        MyRotues.itempagewRoute: (context) => const ItemPageW(),
        MyRotues.orderpagewRoute: (context) => const OrderPageW(),
        MyRotues.choosetablewRoute: (context) => const ChooseTableW(),
        MyRotues.givenorderpagewRoute: (context) => const GivenOrderPageW(),
        MyRotues.pendingdeliverywRoute: (context) => const PendingDeliveryW(),

        //....................Chef............................
        MyRotues.foodmakingRoute: (context) => const Foodmakingchef(),

        //....................Cashier............................
        // Tableselectcashier
        MyRotues.billRoutecashier: (context) => const Billpage(),
        MyRotues.printbillRoutecashier: (context) => const PrintBill(),
        MyRotues.tableRoutecashier: (context) => const Tableselectcashier(),
      },
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
