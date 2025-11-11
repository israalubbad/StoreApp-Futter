import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/favorite.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/favorite_provider.dart';
import '../../../widgets/product_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favoriteItem;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Favorites'),
        centerTitle: true,
      ),
      body: favorites.isEmpty
          ? const Center(
        child: Text(
          'No favorite products yet',
          style: TextStyle(fontSize: 16),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final favorite = favorites[index];
          return ProductCard(
            product: getProduct(favorite),
            isAdmin: false,
          );
        },
      ),
    );
  }

  Product getProduct(Favorite favorite) {
    Product product = Product();
    product.id = favorite.productId;
    product.name = favorite.productName;
    product.price = favorite.price;
    product.imagePath = favorite.imagePath;
    product.info = favorite.info;
    product.quantity = favorite.quantity;

    return product;
  }
}
