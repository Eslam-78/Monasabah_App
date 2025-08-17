import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  static const String _favoriteKeyPrefix = 'favorite_';

  Future<void> addToFavorites(int customerId, Map<String, dynamic> service) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList('$_favoriteKeyPrefix$customerId') ?? [];
    favoriteList.add(jsonEncode(service));
    await prefs.setStringList('$_favoriteKeyPrefix$customerId', favoriteList);
  }

  Future<void> removeFromFavorites(int customerId, Map<String, dynamic> service) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList('$_favoriteKeyPrefix$customerId') ?? [];
    favoriteList.remove(jsonEncode(service));
    await prefs.setStringList('$_favoriteKeyPrefix$customerId', favoriteList);
  }

  Future<List<Map<String, dynamic>>> getFavorites(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriteList = prefs.getStringList('$_favoriteKeyPrefix$customerId') ?? [];
    return favoriteList.map((e) => jsonDecode(e) as Map<String, dynamic>).toList();
  }

  Future<void> clearFavorites(int customerId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('$_favoriteKeyPrefix$customerId');
  }
}
