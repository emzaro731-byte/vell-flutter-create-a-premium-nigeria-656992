import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const PremiumNigerianStoreApp());
}

class PremiumNigerianStoreApp extends StatelessWidget {
  const PremiumNigerianStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Premium Nigerian Store',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const HomePage(),
    );
  }
}

// ---------- Mock Data ----------
class Product {
  final int id;
  final String name;
  final String category;
  final double price; // in Naira
  final String description;
  final IconData icon;

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.icon,
  });
}

const List<String> mockCategories = [
  'All',
  'Fashion',
  'Electronics',
  'Home',
  'Beauty',
];

final List<Product> mockProducts = [
  Product(
    id: 1,
    name: 'Ankara Dress',
    category: 'Fashion',
    price: 25000,
    description:
        'Elegant Ankara dress made from premium fabric. Perfect for parties and events.',
    icon: Icons.checkroom,
  ),
  Product(
    id: 2,
    name: 'Smartphone X12',
    category: 'Electronics',
    price: 150000,
    description:
        'Latest Android smartphone with high-resolution camera and long battery life.',
    icon: Icons.smartphone,
  ),
  Product(
    id: 3,
    name: 'Wooden Chair',
    category: 'Home',
    price: 18000,
    description:
        'Handcrafted wooden chair with a comfortable cushion. Ideal for dining rooms.',
    icon: Icons.chair,
  ),
  Product(
    id: 4,
    name: 'Facial Serum',
    category: 'Beauty',
    price: 12000,
    description:
        'Nourishing facial serum enriched with natural oils for glowing skin.',
    icon: Icons.face,
  ),
  Product(
    id: 5,
    name: 'Leather Handbag',
    category: 'Fashion',
    price: 35000,
    description:
        'Stylish leather handbag with spacious interior and sturdy straps.',
    icon: Icons.shopping_bag,
  ),
  Product(
    id: 6,
    name: 'Bluetooth Headphones',
    category: 'Electronics',
    price: 45000,
    description:
        'Wireless Bluetooth headphones with noise cancellation and 20h battery.',
    icon: Icons.headphones,
  ),
];

// ---------- Home Page ----------
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String _selectedCategory = 'All';

  List<Product> get _filteredProducts {
    return mockProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category == _selectedCategory;
      final matchesSearch = product.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  void _updateSearch(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Nigerian Store'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: _updateSearch,
              decoration: InputDecoration(
                hintText: 'Search products',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
              ),
            ),
          ),
          // Category Chips
          SizedBox(
            height: 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: mockCategories.length,
              itemBuilder: (context, index) {
                final category = mockCategories[index];
                final isSelected = category == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) => _selectCategory(category),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          // Product Grid
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text('No products found.'))
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return ProductCard(product: product);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ---------- Product Card ----------
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final priceFormatted = '₦${product.price.toStringAsFixed(0)}';
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(product: product),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image placeholder
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Icon(
                  product.icon,
                  size: 48,
                  color: Colors.grey[600],
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
              child: Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Text(
                priceFormatted,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(color: Colors.teal[700]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Product Detail ----------
class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  // Mock WhatsApp number (replace with real number when available)
  static const String whatsappNumber = '+2348012345678';

  String get _whatsappMessage {
    final encodedMessage = Uri.encodeComponent(
        'Hello, I would like to order the product "${product.name}" priced at ₦${product.price.toStringAsFixed(0)}.');
    return 'https://wa.me/$whatsappNumber?text=$encodedMessage';
  }

  void _showOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Order via WhatsApp'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tap the button below to copy the WhatsApp link:'),
            const SizedBox(height: 12),
            SelectableText(_whatsappMessage),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: _whatsappMessage));
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('WhatsApp link copied to clipboard')),
              );
            },
            child: const Text('COPY LINK'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('CANCEL'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final priceFormatted = '₦${product.price.toStringAsFixed(0)}';
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Image placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              product.icon,
              size: 80,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            priceFormatted,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(color: Colors.teal[700]),
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => _showOrderDialog(context),
            icon: const Icon(Icons.whatsapp),
            label: const Text('Order via WhatsApp'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ],
      ),
    );
  }
}