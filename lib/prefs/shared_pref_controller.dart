
import 'package:shared_preferences/shared_preferences.dart';

enum PrefKeys{
  language,id,name,email,loggedIn, role
}


class SharedPrefController {
  SharedPrefController._();
  late SharedPreferences _sharedPreferences;
  static SharedPrefController? _instance;

  factory SharedPrefController(){

    return _instance ??=  SharedPrefController._(); // static
  }
  Future<void> initPreferences() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }


  Future<bool?> setData(String key, dynamic data) async {
    _sharedPreferences.setBool(PrefKeys.loggedIn.name, true);
    switch (data.runtimeType) {
      case int:
        return _sharedPreferences.setInt(key, data);
      case String:
        return _sharedPreferences.setString(key, data);
      case bool:
        return _sharedPreferences.setBool(key, data);
    }
    return null;
  }

  // generac
  T? getValueFor<T>(String key){
    if(_sharedPreferences.containsKey(key)){
      return _sharedPreferences.get(key) as T ;
    }
    return null;
  }

  Future<bool> removeValueFor(String key) async{
    if(_sharedPreferences.containsKey(key)){
      return _sharedPreferences.remove(key);
    }
    return false;
  }

  Future<bool> clear(){
   return _sharedPreferences.clear();
  }
}
