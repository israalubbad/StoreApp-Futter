import 'package:flutter/cupertino.dart';
import '../database/controllers/favorites_db_controller.dart';
import '../models/favorite.dart';

class FavoriteProvider extends ChangeNotifier {
  List<Favorite> favoriteItem = <Favorite>[];

  final FavoritesDbController _dbController = FavoritesDbController();

  Future<void> read() async {
    favoriteItem = await _dbController.read();
    notifyListeners();
  }

  bool isFavorite(int productId) {
    return favoriteItem.any((fav) => fav.productId == productId);
  }

  Future<void> toggleFavorite(Favorite favorite) async {
    if (isFavorite(favorite.productId)) {
      final existing = favoriteItem.firstWhere((f) => f.productId == favorite.productId);
      await _dbController.delete(existing.id);
      favoriteItem.removeWhere((f) => f.productId == favorite.productId);
    } else {
      int newRowId = await _dbController.create(favorite);
      if (newRowId != 0) {
        favorite.id = newRowId;
        favoriteItem.add(favorite);
      }
    }
    notifyListeners();
  }
}
