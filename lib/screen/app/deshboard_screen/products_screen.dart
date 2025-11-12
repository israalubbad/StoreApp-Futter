import 'package:flutter/material.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';
import 'package:store_app/provider/products_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/screen/app/deshboard_screen/product_screen.dart';
import 'package:provider/provider.dart';

import '../../../widgets/product_card.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProductsProvider>(context, listen: false).read();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       automaticallyImplyLeading: false,
        title: Text('Products'),
        actions: [
          IconButton(
            onPressed: () {
              _confirmLogoutDialog();
            },
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProductScreen()));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductsProvider>(

          builder: (context, ProductsProvider value, child) {
            if (value.products.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: value.products.length,
                itemBuilder: (context, index) {
                  final product = value.products[index];

                  return ProductCard(product: product, isAdmin: true ,index: index);
                },
              );
            } else {
              return Center(
                child: Text(
                  'NO DATA',
                  style: GoogleFonts.cairo(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
          },

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
           ' Are you sure ?',
            style: GoogleFonts.cairo(fontSize: 12, color: Colors.black45),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text(
                'Confirm',
                style: GoogleFonts.cairo(color: Colors.red),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.cairo(color: Colors.blue),
              ),
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

}
