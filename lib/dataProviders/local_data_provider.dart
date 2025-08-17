import 'dart:convert';
import 'dart:developer';

import 'package:monasbah/dataProviders/error/exceptions.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDataProvider {
  SharedPreferences sharedPreferences;

  LocalDataProvider({required this.sharedPreferences});

  Future<void> cacheData({
    required String key,
    required dynamic data,
  }) {
    log("setting sharedPreferences");
    log("key $key");
    log('cached data is $data');
    return sharedPreferences.setString(key, json.encode(data));
  }

  dynamic getCachedData({
    required String key,
    required retrievedDataType,
    dynamic returnType,
  }) {
    try {
      if (sharedPreferences.getString(key) != null) {
        if (returnType == List) {
          final List<dynamic> data = json.decode(
            sharedPreferences.getString(key) ?? '',
          );

          return retrievedDataType.fromJsonList(data);
        } else if (returnType == String) {
          final dynamic data = json.decode(
            sharedPreferences.getString(key) ?? '',
          );

          return data;
        } else {
          final dynamic data = json.decode(
            sharedPreferences.getString(key) ?? '',
          );

          try {
            return retrievedDataType.fromJson(data);
          } catch (e) {
            return data;
          }
        }
      } else {
        throw CacheException();
      }
    } catch (_) {
      throw CacheException();
    }
  }

  Future<bool> clearCache({
    required String key,
  }) {
    return sharedPreferences.remove(key);
  }

  Future<bool> addToCart({
    required CartModel data,
  }) {
    if (sharedPreferences.getString('CACHED_CART') != null) {
      print('cart is not null');
      bool newItem = true;
      dynamic userCart = sharedPreferences.getString('CACHED_CART');
      print('user cart is $userCart');
      List<dynamic> cart = jsonDecode(userCart);

      cart.forEach((element) {
        if (element['name'] == data.name &&
            element['id'].toString() == data.id.toString() &&
            element['category_id'].toString() == data.category_id.toString()) {
          element['quantity'] = (int.parse(element['quantity'].toString()) +
              int.parse(data.quantity.toString()));
          newItem = false;
          return;
        }
      });

      if (newItem) {
        print('new item');
        cart.add(data);
        newItem = false;
      }

      return sharedPreferences.setString('CACHED_CART', json.encode(cart));
    } else {
      print('cart is null');

      List<CartModel> cart = [];
      cart.add(data);

      return sharedPreferences.setString('CACHED_CART', json.encode(cart));
    }
  }

  Future<bool> addToFavorite({
    required ServicesModel data,
    required int customerId,
  }) async {
    final String key = 'CACHED_FAVORITE_$customerId';
    List<dynamic> favorite = [];

    if (sharedPreferences.getString(key) != null) {
      favorite = jsonDecode(sharedPreferences.getString(key)!);

      final index = favorite.indexWhere((element) =>
          element['id'].toString() == data.id.toString() &&
          element['name'].toString() == data.name.toString());

      if (index != -1) {
        // إذا كان موجود نحذفه (تoggling)
        favorite.removeAt(index);
      } else {
        favorite.add(data.toJson());
      }
    } else {
      favorite = [data.toJson()];
    }

    return sharedPreferences.setString(key, json.encode(favorite));
  }
}
