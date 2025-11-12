import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/provider/favorite_provider.dart';
import 'package:store_app/screen/app/products/products_details_screen.dart';
import 'package:store_app/utils/context_extenssion.dart';
import '../models/cart.dart';
import '../models/favorite.dart';
import '../models/process_response.dart';
import '../prefs/shared_pref_controller.dart';
import '../provider/cart_provider.dart';
import '../provider/products_provider.dart';
import '../screen/app/deshboard_screen/product_screen.dart';
class ProductCard extends StatefulWidget {
  final Product product;
  final bool isAdmin;
  final int? index;
  const ProductCard({super.key , required this.product , required this.isAdmin ,this.index});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade100,
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child:Image.file(
            File(widget.product.imagePath),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          widget.product.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Text(
          widget.product.info,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        trailing: widget.isAdmin
        ? Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                _deleteProduct(context ,widget.index!);
              },
              icon: const Icon(Icons.delete, color: Colors.redAccent, size: 22),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(product: widget.product),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 22),
            ),
          ],
        )
        : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(onPressed: (){
              print('cart');
              Provider.of<CartProvider>(context ,listen: false).create(getCart(widget.product));
            }, icon: Icon(Icons.shopping_cart)),

            Consumer<FavoriteProvider>(
              builder: (context, favoriteProvider, child) {
                bool isFav = favoriteProvider.isFavorite(widget.product.id);
                return IconButton(
                  onPressed: () async {
                    int userId = SharedPrefController().getValueFor<int>(PrefKeys.id.name)!;
                    Favorite fav = Favorite();
                    fav.userId = userId;
                    fav.productId = widget.product.id;

                    await favoriteProvider.toggleFavorite(fav);
                    favoriteProvider.read();
                  },
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.grey,
                    size: 24,
                  ),
                );
              },
            ),

          ],
        ),

          onTap: () {
            if (!widget.isAdmin) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsDetailsScreen(product: widget.product),
                ),
              );
            }

    },

      ),
    );
  }

  void _deleteProduct(BuildContext context, int index) async {
    ProcessResponse processResponse = await Provider.of<ProductsProvider>(
        context, listen: false).delete(index);
    print(index);
    context.showSnackBar(
        message: processResponse.message, error: processResponse.success);
  }

  Cart  getCart(Product product){
    Cart cart = Cart();
    cart.productId =product.id;
    cart.price =product.price;
    cart.total =product.price * 1;
    cart.count = 1;
    cart.productName = product.name;
    cart.userId = SharedPrefController().getValueFor<int>(PrefKeys.id.name)!;
    return cart;
  }
}
