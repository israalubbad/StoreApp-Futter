import 'package:flutter/material.dart';
import 'package:store_app/database/controllers/user_db_controller.dart';
import 'package:store_app/models/process_response.dart';
import 'package:store_app/utils/admin_credentials.dart';
import 'package:store_app/utils/context_extenssion.dart';
import 'package:store_app/utils/helpers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../prefs/shared_pref_controller.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Helpers {
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  bool _obscure = true;

  @override
  void initState() {
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text(
              'Welcome back..',
              style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
             'Enter email and password',
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 20.h),
            AppTextField(
              hint: 'Email',
              iconData: Icons.email,
              keyboardType: TextInputType.emailAddress,
              controller: _emailTextController,
            ),
            SizedBox(height: 10.h),
            AppTextField(
              hint: 'Password',
              iconData: Icons.lock,
              keyboardType: TextInputType.text,
              controller: _passwordTextController,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    _obscure = !_obscure;
                  });
                },
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
              ),
              obscureText: _obscure,
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                _performLogin();
              },
              style: ElevatedButton.styleFrom(
                elevation: 3,
                alignment: Alignment.center,
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Login',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Don\' Have Account ?'),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/register_screen');
                },child: Text('Create Now')),

              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _performLogin() {
    if (_checkData()) {
      _login();
    }
  }

  bool _checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty) {
      return true;
    }
    showSnackBar(context, message: 'Enter required data', error: true);

    return false;
  }

  Future<void> _login() async {
    if (_emailTextController.text == AdminCredentials.email && _passwordTextController.text == AdminCredentials.password ){
      SharedPrefController().setData(PrefKeys.email.name,_emailTextController.text);
      SharedPrefController().setData(PrefKeys.role.name, 'admin');
      Navigator.pushReplacementNamed(context, '/products_screen');
    }else{
      ProcessResponse processResponse  = await UserDbController().login(email: _emailTextController.text, password: _passwordTextController.text);
      print(processResponse.success);
      if(processResponse.success){
        await Navigator.pushReplacementNamed(context, '/mainAppView');
      }
      context.showSnackBar(message: processResponse.message,error: processResponse.success);


    }



  }
}
