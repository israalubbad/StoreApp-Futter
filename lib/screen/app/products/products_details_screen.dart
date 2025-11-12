import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/product.dart';

import '../../../models/cart.dart';
import '../../../prefs/shared_pref_controller.dart';
import '../../../provider/cart_provider.dart';

class ProductsDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductsDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details', style: GoogleFonts.cairo()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.file(
              File(product.imagePath),
              width: double.infinity,
              height: 280,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Card(
              margin: const EdgeInsets.all(16),
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.cairo(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      product.info,
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Price:', style: GoogleFonts.cairo(fontSize: 18)),
                        Text(
                          '${product.price}',
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,

                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Quantity:',
                          style: GoogleFonts.cairo(fontSize: 18),
                        ),
                        Text(
                          '${product.quantity}',
                          style: GoogleFonts.cairo(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Provider.of<CartProvider>(
                            context,
                            listen: false,
                          ).create(getCart(product));
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: Text('Add to Cart', style: GoogleFonts.cairo()),

                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Cart getCart(Product product) {
    Cart cart = Cart();
    cart.productId = product.id;
    cart.price = product.price;
    cart.total = product.price * 1;
    cart.count = 1;
    cart.productName = product.name;
    cart.userId = SharedPrefController().getValueFor<int>(PrefKeys.id.name)!;
    return cart;
  }
}
