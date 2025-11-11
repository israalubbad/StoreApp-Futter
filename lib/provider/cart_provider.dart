import 'package:flutter/material.dart';
import 'package:store_app/database/controllers/cart_db_controller.dart';
import 'package:store_app/database/controllers/products_db_controller.dart';
import 'package:store_app/models/cart.dart';
import 'package:store_app/models/process_response.dart';


class CartProvider extends ChangeNotifier{
  List<Cart> cartItem = <Cart>[];

  final CartDbController _dbController = CartDbController();
  final ProductsDbController _productController = ProductsDbController();
  double total = 0;
  int quantity = 0;

  Future<ProcessResponse> create (Cart cart)async{
    int index = cartItem.indexWhere((element) =>  element.productId == cart.productId,) ;
    if(index == -1){
      int newRowId = await _dbController. create(cart);
      if(newRowId != 0){
        cart.id = newRowId;
        total += cart.total;
        quantity += 1;
        cartItem.add(cart);
        notifyListeners();
      }
      return getResponse(newRowId != 0);
    }else{
      int quantity = await _productController.getQuantity(cart.productId);
      int newCount = cartItem[index].count + 1;
      if(quantity >= newCount){
        return changeQuantity(index,newCount);
      }
      return getResponse(false);
    }
  }

  void read () async{
    cartItem = await _dbController.read();
    total = 0;
     quantity = 0;
    for(Cart cart in cartItem){
      total += cart.total;
      quantity += cart.count;
    }
    notifyListeners();
  }

  Future<ProcessResponse> changeQuantity(int index, int count) async {
    Cart cart = cartItem[index];
    bool isDelete = count == 0;

    bool result;
    if (isDelete) {
      result = await _dbController.delete(cart.id);
    } else {
      cart.count = count;
      cart.total = cart.price * count;
      result = await _dbController.update(cart);
    }

    if (result) {
      if (isDelete) {
        cartItem.removeAt(index);
      } else {
        cartItem[index] = cart;
      }

      total = 0;
      quantity = 0;
      for (Cart item in cartItem) {
        total += item.total;
        quantity += item.count;
      }

      notifyListeners();
    }

    return getResponse(result);
  }


  Future<ProcessResponse> clear ()async{
   bool cleared = await _dbController.clear();
   if(cleared) {
     cartItem.clear();
     total = 0;
     quantity = 0;
     notifyListeners();
   }
    return getResponse(cleared);
  }

  ProcessResponse getResponse(bool success){
    return  ProcessResponse(message:success  ? 'Operation Completed successfully' : 'Operation failed!',success: success);
  }
}