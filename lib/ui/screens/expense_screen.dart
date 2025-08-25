import 'package:flutter/material.dart';

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Expenses")),
      body: ListView.builder(
        itemCount: 10, // replace with DB stream
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: Text("Groceries"),
            subtitle: Text("Feb 20, 2025"),
            trailing: Text(
              "- 500 ETB",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add expense form
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
