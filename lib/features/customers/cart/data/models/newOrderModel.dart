import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'cartModel.dart';

class NewOrderModel extends Equatable {
  dynamic location_id, total, delivery_date, payMethode,orders, token;

  NewOrderModel({
    this.location_id,
    required this.delivery_date,
    required this.total,
    required this.payMethode,
    required this.orders,
    required this.token,
  });

  factory NewOrderModel.fromJson(Map<String, dynamic> order) {
    return NewOrderModel(
        location_id: order['location_id'],
        delivery_date: order['delivery_date'],
        total: order['total'],
        payMethode: order['payMethode'],
        orders: order['orders'],
        token: order['token']);
  }

  NewOrderModel fromJson(Map<String, dynamic> json) {
    return NewOrderModel.fromJson(json);
  }

  factory NewOrderModel.init() {
    return NewOrderModel(
        location_id: 0,
        total: 0,
        delivery_date: 0,
        payMethode: '',
        orders: '',
        token: '');
  }

  fromJsonList(List<dynamic> jsonList) {
    List<NewOrderModel> data = [];
    jsonList.forEach((post) {
      data.add(NewOrderModel.fromJson(post));
    });
    return data;
  }

  Map<String, dynamic> toJson() => {
        'location_id': location_id,
        'delivery_date': delivery_date,
        'total': total,
        'payMethode': payMethode,
        'orders': orders,
        'api_token': token
      };

  @override
  List<Object?> get props =>
      [location_id, delivery_date, total, payMethode, orders, token];
}
