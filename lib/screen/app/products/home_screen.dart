import 'package:flutter/material.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';
import 'package:store_app/provider/favorite_provider.dart';
import 'package:store_app/provider/products_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../provider/cart_provider.dart';
import '../../../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<CartProvider>(context, listen: false).read();
    Provider.of<FavoriteProvider>(context, listen: false).read();
    Provider.of<ProductsProvider>(context, listen: false).read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            onPressed: _confirmLogoutDialog,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: (query) => _productSearch(),
              decoration: InputDecoration(
                hintText: 'Search Products ..',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ProductsProvider>(
                builder: (context, productsProvider, child) {
                  if (productsProvider.products.isEmpty) {
                    return Center(
                      child: Text(
                        'No products found',
                        style: GoogleFonts.cairo(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    itemCount: productsProvider.products.length,
                    itemBuilder: (context, index) {
                      final product = productsProvider.products[index];
                      return ProductCard(
                        product: product,
                        isAdmin: false,
                        index: index,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogoutDialog() async {
    bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(
            'Confirm logout',
            style: GoogleFonts.cairo(fontSize: 14, color: Colors.black),
          ),
          content: Text(
            'Are you sure?',
            style: GoogleFonts.cairo(fontSize: 12, color: Colors.black45),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('Confirm',
                  style: GoogleFonts.cairo(color: Colors.red)),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('Cancel',
                  style: GoogleFonts.cairo(color: Colors.blue)),
            ),
          ],
        );
      },
    );

    if (result ?? false) {
      bool cleared = await SharedPrefController().clear();
      if (cleared) {
        Navigator.pushReplacementNamed(context, '/login_screen');
      }
    }
  }

  void _productSearch() async {
    final query = _searchController.text.trim();
    final provider = Provider.of<ProductsProvider>(context, listen: false);

    if (query.isEmpty) {
      await provider.read();
    } else {
      await provider.search(query);
    }
  }
}
