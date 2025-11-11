
import 'package:flutter/material.dart';
import 'package:store_app/screen/app/favorite/favorite_screen.dart';
import 'package:store_app/screen/app/products/home_screen.dart';

import 'cart/cart_screen.dart';


class MainAppView extends StatefulWidget {
  const MainAppView({super.key});

  @override
  State<MainAppView> createState() => _MainAppViewState();
}

class _MainAppViewState extends State<MainAppView> {
  int _currentIndex = 0;


  late List<Widget?> screensList = [
    const HomeScreen(),
    const CartScreen(),
    const FavoriteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screensList[_currentIndex],
      extendBody: true,
      bottomNavigationBar:
      ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50) , topRight: Radius.circular(50)),
        child: BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          backgroundColor: Colors.grey.shade100,
          selectedItemColor: Colors.blue,
          selectedIconTheme: const IconThemeData(size: 28),
          unselectedItemColor: Colors.grey,
          currentIndex: _currentIndex,
          onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: ''),
          ],
        ),
    )

    );
  }
}
