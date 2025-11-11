import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:store_app/screen/app/main_app_view.dart';
import 'package:store_app/screen/app/products/products_details_screen.dart';

import '../screen/app/deshboard_screen/products_screen.dart';
import '../screen/auth/login_screen.dart';
import '../screen/auth/register_screen.dart';
import '../screen/core/launch_screen.dart';

extension ContextHelper on BuildContext{

  Map<String,WidgetBuilder> get routes => {
    '/launch_screen': (context) => const LaunchScreen(),
    '/login_screen': (context) => const LoginScreen(),
    '/mainAppView': (context) => const MainAppView(),
    '/register_screen': (context) => const  RegisterScreen(),
    '/products_screen': (context) => const ProductsScreen(),
    //'/products_details_screen': (context) => const ProductsDetailsScreen(),
  //  '/cart_screen': (context) => const CartScreen(),
    // '/product_screen': (context) => const ProductScreen(),

  };


  void showSnackBar({
        required String message,
        bool error = false,
      }) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(
        message, style: GoogleFonts.cairo(),
      ),
        backgroundColor: error ? Colors.blue.shade300 : Colors.red.shade700  ,
        duration: const Duration(seconds: 3),
        dismissDirection: DismissDirection.horizontal,

      ),
    );
  }



}

