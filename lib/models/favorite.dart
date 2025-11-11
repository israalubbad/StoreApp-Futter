class Favorite {
  late int id;
  late int userId;
  late int productId;
  late String productName;
  late String info;
  late double price;
  late String imagePath;
  late int quantity;


  Favorite();
  static const String tableName = 'favorites';

  /// Read row data from database table
  Favorite.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap['id'];
    productId = rowMap['product_id'];
    userId = rowMap['user_id'];
    productName = rowMap['product_name'];
    info = rowMap['info'];
    price = rowMap['price'];
    imagePath = rowMap['image_path'];
    quantity = rowMap['quantity'];

  }

  /// Prepare map to saved in database
  Map<String,dynamic> toMap(){
    Map<String ,dynamic> map = <String ,dynamic>{};
    map['product_id'] = productId ;
    map['user_id'] = userId ;

    return map;
  }
}
