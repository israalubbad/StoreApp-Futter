class Product {
  late int id;
  late String name;
  late String info;
  late String imagePath;
  late double price;
  late int quantity;

  Product();
  static const String tableName = 'products';

  /// Read row data from database table
  Product.fromMap(Map<String, dynamic> rowMap) {

    id = rowMap['id'];
    name = rowMap['name'];
    info = rowMap['info'];
    price = rowMap['price'];
    imagePath = rowMap['image_path'];
    quantity = rowMap['quantity'];
  //  userId = rowMap['user_id'];
  }
  /// Prepare map to saved in database
  Map<String,dynamic> toMap(){
    Map<String ,dynamic> map = <String ,dynamic>{};

    map['name'] = name ;
    map['info'] = info ;
    map['image_path'] = imagePath ;
    map['price'] = price ;
    map['quantity'] = quantity ;

    return map;
  }
}
