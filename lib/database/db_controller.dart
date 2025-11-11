import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbController{
  // Singleton Pattern
  late Database _database;

  DbController._();
  static DbController? _instance;

  factory DbController(){
    return _instance ??=  DbController._();
  }
  Database get database => _database;

  Future<void> initDatabase() async{
    Directory directory =await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'app_db.sql');
    _database = await openDatabase(
      path,
      version: 1,
      onOpen: (Database database){

      },
      onCreate: (Database database , int version) async{
        // TODO: Create tables(users , products, cart) USING SQL
        await database.execute('CREATE TABLE users ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'name TEXT NOT NULL,'
            'email TEXT NOT NULL,'
            'password TEXT NOT NULL'
            ''
            ')');

        await database.execute('CREATE TABLE products ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'name TEXT NOT NULL,'
            'info TEXT NOT NULL,'
            'price REAL NOT NULL,'
            'image_path TEXT,'
            'quantity INTEGER DEFAULT (0)'
            ')');

        await database.execute('CREATE TABLE cart ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'count INTEGER NOT NULL,'
            'total REAL NOT NULL,'
            'price REAL NOT NULL,'
            'user_id INTEGER,'
            'product_id INTEGER,'
            'FOREIGN KEY (user_id) references users(id),'
            'FOREIGN KEY (product_id) references users(id)'
            ')');

        await database.execute('CREATE TABLE favorites ('
            'id INTEGER PRIMARY KEY AUTOINCREMENT,'
            'user_id INTEGER,'
            'product_id INTEGER,'
            'FOREIGN KEY (user_id) references users(id),'
            'FOREIGN KEY (product_id) references users(id)'
            ')');
      },



      onUpgrade: (Database database, int oldVersion , int newVersion){},
      onDowngrade: (Database database, int oldVersion , int newVersion){},
    );
  }
}