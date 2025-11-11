import 'package:store_app/database/db_controller.dart';
import 'package:store_app/models/process_response.dart';
import 'package:store_app/models/user.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';
import 'package:sqflite/sqflite.dart';

class UserDbController {
  // Login , Register

  final Database _database = DbController().database;

  Future<ProcessResponse> login({required String email, required String password}) async {
    List<Map<String, dynamic>> rowsMap = await _database.query(
      User.tableName,
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );
    if(rowsMap.isNotEmpty){
      User user = User.fromMap(rowsMap.first);
      SharedPrefController().setData(PrefKeys.email.name, user.email);
      SharedPrefController().setData(PrefKeys.name.name, user.name);
      SharedPrefController().setData(PrefKeys.id.name, user.id);
      SharedPrefController().setData(PrefKeys.role.name, 'user');
      return ProcessResponse(message: 'Logged in Successfully',success: true);
    }

    return ProcessResponse(message: 'Credentials error, check and try again!');
  }

  Future<ProcessResponse> register({required User user}) async {
    if (await _isEmailExist(email: user.email)) {
      int newRowId = await _database.insert(User.tableName, user.toMap());
      return ProcessResponse(
        message: newRowId != 0
            ? 'Registered successfully'
            : 'Registered failed!',
        success: newRowId != 0,
      );
    } else {
      return ProcessResponse(
        message: 'Email exist ,use another',
        success: false,
      );
    }
  }


  Future<bool> _isEmailExist({required String email}) async {
    List<Map<String, dynamic>> rowsMap = await _database.rawQuery(
      'SELECT * FROM users WHERE email = ?',
      [email],
    );

    return rowsMap.isEmpty;
  }
}