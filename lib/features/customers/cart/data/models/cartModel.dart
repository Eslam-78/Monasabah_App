import 'package:equatable/equatable.dart';

class CartModel extends Equatable {
  dynamic name, unit, image;
  dynamic id, category_id;
  int totalPrice, unitPrice, quantity;

  CartModel(
      {required this.id,
      required this.category_id,
      required this.name,
      required this.unit,
      required this.unitPrice,
      required this.image,
      required this.quantity,
      required this.totalPrice,

      });

  factory CartModel.fromJson(Map<String, dynamic> cart) {
    return CartModel(
        id: cart['id'],
        category_id: cart['category_id'],
        name: cart['name'],
        unit: cart['unit'],
        unitPrice: cart['unitPrice'],
        image: cart['image'],
        totalPrice: cart['totalPrice'],
        quantity: cart['quantity']);
  }

  CartModel fromJson(Map<String, dynamic> json) {
    return CartModel.fromJson(json);
  }

  factory CartModel.init() {
    return CartModel(
        id: '',
        category_id: '',
        name: '',
        unit: '',
        unitPrice: 0,
        image: '',
        totalPrice: 0,
        quantity: 0);
  }

  fromJsonList(List<dynamic> jsonList) {
    List<CartModel> data = [];
    jsonList.forEach((post) {
      data.add(CartModel.fromJson(post));
    });
    return data;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'category_id': category_id,
        'name': name,
        'unit': unit,
        'unitPrice': unitPrice,
        'image': image,
        'totalPrice': totalPrice,
        'quantity': quantity
      };

  @override
  List<Object?> get props =>
      [id, category_id, name, unit, unitPrice, image, totalPrice, quantity];
}
