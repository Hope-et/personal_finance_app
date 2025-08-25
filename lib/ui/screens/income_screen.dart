import 'package:flutter/material.dart';

class IncomeScreen extends StatelessWidget {
  const IncomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Income")),
      body: ListView.builder(
        itemCount: 5, // replace with DB stream
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.attach_money, color: Colors.green),
            title: Text("Salary"),
            subtitle: Text("Feb 10, 2025"),
            trailing: Text(
              "+ 15,000 ETB",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add income form
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
