import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text('Add Expense'),
        centerTitle: true,
      ),

// date\nitem name\nprice\ntax--VAT/GST\nfrom where\nwho\nattechment\nrefrence

      body: Column(
        children: [
          //Item Name
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Item Name',
            ),
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //Price
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Price',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //TAX
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'TAX',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //Who
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Who',
            ),
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
          ),
          //From Where
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'From Where',
            ),
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //Refrence
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Refrence',
            ),
            keyboardType: TextInputType.text,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),

          //Date
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Date',
            ),
            keyboardType: TextInputType.datetime,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ], // Only numbers can be entered
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          //Attechment
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.attach_file_sharp),
          ),
        ],
      ),
    );
  }
}
