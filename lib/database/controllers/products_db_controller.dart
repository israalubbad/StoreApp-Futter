import 'package:store_app/database/db_operations.dart';
import 'package:store_app/models/product.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';

class ProductsDbController extends DbOperations<Product> {
  // CRUD : Create - Read - Update - Delete

  @override
  Future<int> create(Product model) async {
    return await database.insert(Product.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id) async {
    int countOfDeletedRow = await database.delete(
      Product.tableName,
      where: 'id= ?',
      whereArgs: [id],
    );
    return countOfDeletedRow == 1;
  }

  @override
  Future<List<Product>> read() async {
    List<Map<String, dynamic>> rowsMap = await database.query(
        Product.tableName,where: 'quantity > 0' ,
    );
    return rowsMap.map((rowMap) => Product.fromMap(rowMap)).toList();
  }

  @override
  Future<Product?> show(int id) async {
    List<Map<String, dynamic>> rowsMap = await database.query(
      Product.tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return rowsMap.isNotEmpty ? Product.fromMap(rowsMap.first) : null;
  }
  Future<List<Product>> search(String name) async {
    List<Map<String, dynamic>> rowsMap = await database.query(
      Product.tableName,
      where: 'name LIKE ?',
      whereArgs: ['%$name%'],
    );
    return rowsMap.map((row) => Product.fromMap(row)).toList();
  }


  @override
  Future<bool> update(Product model) async {
    int countOfUpdateRow = await database.update(
      Product.tableName,
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return countOfUpdateRow == 1;
  }

  Future<int> getQuantity(int id) async{
    List<Map<String,dynamic>> rowsMap =  await database.query(Product.tableName ,where: 'id = ?' , whereArgs: [id]);
    return Product.fromMap(rowsMap.first).quantity;

  }


}
