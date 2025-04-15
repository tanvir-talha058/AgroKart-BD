import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import 'product_detail_screen.dart';
import 'cart_screen.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final double rating;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
  });
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Product> _homeScreenProducts = [
    Product(
      name: 'Fresh Carrots',
      imageUrl: 'https://images.pexels.com/photos/65174/pexels-photo-65174.jpeg',
      price: 1.99,
      rating: 4.5,
    ),
    Product(
      name: 'Organic Tomatoes',
      imageUrl:
      'https://images.pexels.com/photos/1367242/pexels-photo-1367242.jpeg',
      price: 2.49,
      rating: 4.8,
    ),
    Product(
      name: 'Fresh Onions',
      imageUrl: 'https://images.pexels.com/photos/175414/pexels-photo-175414.jpeg',
      price: 1.29,
      rating: 4.6,
    ),
    Product(
      name: 'Fresh Potatoes',
      imageUrl:
      'https://images.pexels.com/photos/144248/potatoes-vegetables-erdfrucht-bio-144248.jpeg',
      price: 1.59,
      rating: 4.7,
    ),
  ];

  List<Product> _filteredProducts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredProducts = _homeScreenProducts;
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredProducts = _homeScreenProducts
          .where((product) =>
      product.name.toLowerCase().contains(query) ||
          product.name.toLowerCase().startsWith(query))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: const Text(
          'AgroKart BD',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartScreen(
                        homeScreenProducts: _homeScreenProducts)), // Pass the product list
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for products',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_searchController.text.isNotEmpty) ...[
              // Show the search suggestions when the search field is not empty
              Text(
                'Search Suggestions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildSearchSuggestions(),
            ],
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text('Fresh Vegetables in your Door',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Text('Up to 50% discount',
                              style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  Image.network(
                    'https://media.istockphoto.com/id/174429248/photo/fresh-vegetables.jpg?s=612x612&w=0&k=20&c=fxlgOIET7gKa8M3rwkV974aUfB0gVpWiJQwUoxA4dtQ=',
                    width: 170,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text('Categories',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('See all',
                    style: TextStyle(fontSize: 14, color: Colors.green)),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              children: [
                Chip(label: Text('All'), backgroundColor: Colors.green[100]),
                Chip(label: Text('Vegetables')),
                Chip(label: Text('Fruits')),
                Chip(label: Text('Crops')),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3 / 4,
              children: _filteredProducts
                  .map((product) => _buildProductCard(context, product: product))
                  .toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildProductCard(BuildContext context, {required Product product}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (_, __, ___) => ProductDetailScreen(
              name: product.name,
              imageUrl: product.imageUrl,
              price: product.price,
              rating: product.rating,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: product.imageUrl,
              child: ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.network(
                  product.imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('\$${product.price.toStringAsFixed(2)}',
                      style:
                      const TextStyle(fontSize: 14, color: Colors.green)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 16),
                      const SizedBox(width: 4),
                      Text(product.rating.toString(),
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Custom widget for search suggestions
  Widget _buildSearchSuggestions() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                  name: product.name,
                  imageUrl: product.imageUrl,
                  price: product.price,
                  rating: product.rating,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Card(
              elevation: 3,
              child: ListTile(
                contentPadding: const EdgeInsets.all(8.0),
                leading: Image.network(
                  product.imageUrl,
                  height: 50,
                  width: 50,
                  fit: BoxFit.cover,
                ),
                title: Text(product.name, style: TextStyle(fontSize: 14)),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              ),
            ),
          ),
        );
      },
    );
  }
}
