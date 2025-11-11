  class Cart {
  late int id;
  late double total;
  late double price;
  late int count;
  late int userId;
  late int productId;
  late String productName;
  late String imagePath;
  late int quantity;


  Cart();
  static const String tableName = 'cart';

  /// Read row data from database table
  Cart.fromMap(Map<String, dynamic> rowMap) {
    id = rowMap['id'];
    total = rowMap['total'];
    count = rowMap['count'];
    price = rowMap['price'];
    productId = rowMap['product_id'];
    userId = rowMap['user_id'];
    productName = rowMap['product_name'];
    imagePath = rowMap['image_path'];
    quantity = rowMap['quantity'];

  }
  /// Prepare map to saved in database
  Map<String,dynamic> toMap(){
    Map<String ,dynamic> map = <String ,dynamic>{};
    // no id its autoincrement
    map['total'] = total ;
    map['count'] = count ;
    map['price'] = price ;
    map['product_id'] = productId ;
    map['user_id'] = userId ;


    return map;
  }
}
//Image.file(
  //   File(cart.imagePath),
  //   width: 100,
  //   height: 100,
  //   fit: BoxFit.cover,
  // )