import 'package:flutter/material.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  @override
  @override
  void initState() {
   Future.delayed(Duration(seconds: 3),(){
     String? role = SharedPrefController().getValueFor<String>(PrefKeys.role.name);

     if (role == 'admin') {
       Navigator.pushReplacementNamed(context, '/products_screen');
     } else if (role == 'user') {
       Navigator.pushReplacementNamed(context, '/mainAppView');
     } else {
       Navigator.pushReplacementNamed(context, '/login_screen');
     }

   });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            end: AlignmentDirectional.topStart,
            begin: AlignmentDirectional.bottomEnd,
            colors: [Colors.pink.shade100, Colors.blue.shade100],
          ),
        ),
        child: Text('Store App', style: GoogleFonts.cairo(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white
        )),
      ),
    );
  }
}
