import 'dart:convert';

import 'package:equatable/equatable.dart';

class MyOrdersModel extends Equatable {
  dynamic id,
      total,
      delivery_date,
      locationName,
      description,
      lat,
      long,
      status;
  List<dynamic> orders;

  //TODO::here add the required for token and id
  MyOrdersModel(
      {this.id,
      required this.locationName,
      required this.delivery_date,
      required this.total,
      required this.description,
      required this.status,
      required this.long,
      required this.lat,
      required this.orders});

  factory MyOrdersModel.fromJson(Map<String, dynamic> order) {
    return MyOrdersModel(
        id: order['id'],
        locationName: order['locationName'],
        delivery_date: order['delivery_date'],
        total: order['total'],
        description: order['description'],
        status: order['status'],
        lat: order['lat'],
        long: order['long'],
        orders: order['orders'] as List<dynamic>);
  }

  MyOrdersModel fromJson(Map<String, dynamic> json) {
    return MyOrdersModel.fromJson(json);
  }

  factory MyOrdersModel.init() {
    return MyOrdersModel(
      id: 0,
      total: 0,
      locationName: 0,
      delivery_date: 0,
      description: '',
      status: '',
      long: 0.0,
      lat: 0.0,
      orders: [],
    );
  }

  fromJsonList(List<dynamic> jsonList) {
    List<MyOrdersModel> data = [];
    jsonList.forEach((post) {
      data.add(MyOrdersModel.fromJson(post));
    });
    return data;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'locationName': locationName,
        'delivery_date': delivery_date,
        'total': total,
        'description': description,
        'status': status,
        'lat': lat,
        'long': long,
        'orders': orders,
      };

  @override
  List<Object?> get props => [
        id,
        locationName,
        delivery_date,
        total,
        description,
        lat,
        long,
        status,
        orders,
      ];
}
