class User {
  late int id;
  late String name;
  late String email;
  late String password;

  User();
  static const String tableName = 'users';


  /// Read row data from database table
  User.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap['id'];
    name = rowMap['name'];
    email = rowMap['email'];
    password = rowMap['password'];
  }
  /// Prepare map to saved in database
  Map<String,dynamic> toMap(){
    Map<String ,dynamic> map = <String ,dynamic>{};
    // no id its autoincrement
    map['name'] = name ;
    map['email'] = email ;
    map['password'] = password ;

    return map;
  }
}
