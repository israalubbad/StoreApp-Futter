import 'package:store_app/database/db_operations.dart';
import 'package:store_app/models/cart.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';

class CartDbController extends DbOperations<Cart>{
  // CRUD : Create - Read - Update - Delete
  int userId =SharedPrefController().getValueFor<int>(PrefKeys.id.name)!;

  @override
  Future<Cart?> show(int id) {
    throw UnimplementedError();
  }

  @override
  Future<int> create(Cart model) async{
    // User add new Item for the first time to the cart
    return await database.insert(Cart.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id)async {
   int countOfDeletedRows = await database.delete(Cart.tableName,where: 'id = ? AND user_id = ?',whereArgs: [id,userId]);
   return countOfDeletedRows == 1 ;
  }

  @override
  Future<List<Cart>> read() async{
    List<Map<String,dynamic>> rowsMap = await database.rawQuery(
        'SELECT cart.id , cart.user_id, cart.product_id ,cart.count , cart.total , cart.price , products.name as product_name , products.image_path As image_path , products.quantity  '
        'FROM cart JOIN products ON cart.product_id = products.id '
        'WHERE cart.user_id = ? ' ,[userId]
    );
    return rowsMap.map((rowMap) => Cart.fromMap(rowMap)).toList();
  }

  @override
  Future<bool> update(Cart model) async {
    int countOfUpdatedRows = await database.update(Cart.tableName,model.toMap(), where: 'id = ? And user_id = ?' , whereArgs: [model.id,userId]);
    return countOfUpdatedRows == 1;

  }
  
  @override
  Future<bool> clear() async{
   int countOfDeletedRows = await database.delete(Cart.tableName, where: 'user_id = ?' , whereArgs:  [userId]);
    return countOfDeletedRows > 0;
  }



}