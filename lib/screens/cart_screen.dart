import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, String>> cartItems = [
    {"name": "Fresh Tomato", "quantity": "2kg", "price": "৳120"},
    {"name": "Organic Cucumber", "quantity": "1kg", "price": "৳40"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Cart")),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: cartItems.map((item) {
          return Card(
            child: ListTile(
              title: Text(item["name"]!),
              subtitle: Text("Quantity: ${item["quantity"]}"),
              trailing: Text(item["price"]!),
            ),
          );
        }).toList(),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          child: Text("Proceed to Checkout"),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Checkout feature coming soon!")),
            );
          },
        ),
      ),
    );
  }
}
