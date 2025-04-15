import 'package:flutter/material.dart';
import 'package:agrokartminimal/screens/home_screen.dart'; // Adjust the import path

class CartItem {
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  final List<Product> homeScreenProducts;

  const CartScreen({super.key, required this.homeScreenProducts});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late List<CartItem> _cartItems;

  @override
  void initState() {
    super.initState();
    _cartItems = widget.homeScreenProducts.map((product) => CartItem(
      name: product.name,
      imageUrl: product.imageUrl,
      price: product.price,
    )).toList();
  }

  double get subtotal {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  double get taxes {
    return subtotal * 0.034; // Example tax rate of 3.4%
  }

  double get total {
    return subtotal + taxes;
  }

  void _increaseQuantity(int index) {
    setState(() {
      _cartItems[index].quantity++;
    });
  }

  void _decreaseQuantity(int index) {
    if (_cartItems[index].quantity > 1) {
      setState(() {
        _cartItems[index].quantity--;
      });
    } else {
      _removeItem(index);
    }
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              setState(() {
                _cartItems.clear();
              });
            },
          ),
        ],
      ),
      body: _cartItems.isEmpty
          ? const Center(
        child: Text('Your cart is empty.'),
      )
          : ListView.builder(
        itemCount: _cartItems.length,
        itemBuilder: (context, index) {
          final item = _cartItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          Text('\$${item.price.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () => _increaseQuantity(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.add, size: 16),
                          ),
                        ),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 4.0),
                          child: Text('${item.quantity}',
                              style:
                              const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        GestureDetector(
                          onTap: () => _decreaseQuantity(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(Icons.remove, size: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _cartItems.isNotEmpty
          ? Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:',
                    style: TextStyle(fontSize: 16)),
                Text('\$${subtotal.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Taxes:', style: TextStyle(fontSize: 16)),
                Text('\$${taxes.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total:',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text('\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Implement checkout logic
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Check Out functionality')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Check Out', style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      )
          : null,
    );
  }
}