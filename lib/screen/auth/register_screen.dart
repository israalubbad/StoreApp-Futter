import 'package:flutter/material.dart';
import 'package:store_app/database/controllers/user_db_controller.dart';
import 'package:store_app/models/process_response.dart';
import 'package:store_app/models/user.dart';
import 'package:store_app/utils/context_extenssion.dart';
import 'package:store_app/utils/helpers.dart';
import 'package:store_app/widgets/app_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with Helpers {
  late TextEditingController _nameTextController;
  late TextEditingController _emailTextController;
  late TextEditingController _passwordTextController;
  bool _obscure = true;

  @override
  void initState() {
    _nameTextController = TextEditingController();
    _emailTextController = TextEditingController();
    _passwordTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
        centerTitle: true,

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Spacer(),
            Text('Create new account..',
              style: GoogleFonts.cairo(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              'Enter info below',
              style: GoogleFonts.cairo(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),

            SizedBox(height: 20.h),
            AppTextField(
              hint: 'User Name',
              iconData: Icons.person,
              keyboardType: TextInputType.text,
              controller: _nameTextController,
            ),
            SizedBox(height: 10.h),
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
                _performRegister();
              },
              style: ElevatedButton.styleFrom(
                elevation: 3,
                alignment: Alignment.center,
                minimumSize: Size(double.infinity, 50.h),
                backgroundColor: Colors.blue,
              ),
              child: Text(
              'Register',
                style: GoogleFonts.cairo(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Do  Have Account ?'),
                TextButton(onPressed: (){
                  Navigator.pushReplacementNamed(context, '/login_screen');
                },child: Text('LogIn')),

              ],
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  void _performRegister() async {
    if (_checkData()) {
      await _register();
    }
  }

  bool _checkData() {
    if (_emailTextController.text.isNotEmpty &&
        _passwordTextController.text.isNotEmpty &&
        _nameTextController.text.isNotEmpty

    ) {

      return true;
    }
    showSnackBar(context, message: 'Enter required data', error: true);

    return false;
  }

  Future<void> _register()async {
    //TODO : Call Database
  ProcessResponse processResponse  = await UserDbController().register(user: user);
  if(processResponse.success){
     Navigator.pop(context);
  }
  context.showSnackBar(message: processResponse.message ,error: processResponse.success);

  }

  User get user{
    User user =User();
    user.name = _nameTextController.text;
    user.email = _emailTextController.text;
    user.password = _passwordTextController.text;
    return user;
  }
}
