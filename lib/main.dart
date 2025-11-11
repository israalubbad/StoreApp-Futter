
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';
import 'package:store_app/provider/cart_provider.dart';
import 'package:store_app/provider/favorite_provider.dart';
import 'package:store_app/provider/products_provider.dart';
import 'package:store_app/utils/context_extenssion.dart';

import 'database/db_controller.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await  SharedPrefController().initPreferences();
  await DbController().initDatabase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context , child){
        return MultiProvider(
          providers: [
            ChangeNotifierProvider<ProductsProvider>(create: (context) => ProductsProvider()),
            ChangeNotifierProvider<FavoriteProvider>(create: (context) => FavoriteProvider()),
            ChangeNotifierProvider<CartProvider>(create: (context) => CartProvider()),
          ],
          builder: (BuildContext context ,Widget? child ){
            return  MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  appBarTheme: AppBarTheme(
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      iconTheme:const IconThemeData(color:Colors.black ),
                      titleTextStyle: GoogleFonts.cairo(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black
                      )
                  ),

                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 20
                    ),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              initialRoute:'/launch_screen',
              routes: context.routes,
            );

          },
        );

        //   ChangeNotifierProvider<LanguageProvider>(
        //   create: (context) => LanguageProvider(),
        //
        // builder:(BuildContext context , Widget? child){
        // },
        //
        // );

      },
    );
  }
}




