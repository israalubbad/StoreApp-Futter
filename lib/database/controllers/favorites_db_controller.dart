import 'package:store_app/database/db_operations.dart';
import 'package:store_app/models/cart.dart';
import 'package:store_app/models/favorite.dart';
import 'package:store_app/prefs/shared_pref_controller.dart';

class FavoritesDbController extends DbOperations<Favorite>{
  // CRUD : Create - Read - Update - Delete
  int get userId => SharedPrefController().getValueFor<int>(PrefKeys.id.name)!;

  @override
  Future<Favorite?> show(int id) {
    throw UnimplementedError();
  }

  @override
  Future<int> create(Favorite model) async{
    // User add new Item for the first time to the cart
    return await database.insert(Favorite.tableName, model.toMap());
  }

  @override
  Future<bool> delete(int id)async {
    int countOfDeletedRows = await database.delete(Favorite.tableName,where: 'id = ? AND user_id = ?',whereArgs: [id,userId]);
    return countOfDeletedRows == 1 ;
  }

  @override
  Future<List<Favorite>> read() async {
    List<Map<String, dynamic>> rowsMap = await database.rawQuery(
      'SELECT favorites.id, favorites.user_id, favorites.product_id, '
          'products.name AS product_name, products.info AS info, products.price AS price , products.image_path As image_path , products.quantity '
          'FROM favorites JOIN products ON favorites.product_id = products.id '
          'WHERE favorites.user_id = ?',
      [userId],
    );
    return rowsMap.map((rowMap) => Favorite.fromMap(rowMap)).toList();
  }

  @override
  Future<bool> update(Favorite model) {
    // TODO: implement update
    throw UnimplementedError();
  }



}