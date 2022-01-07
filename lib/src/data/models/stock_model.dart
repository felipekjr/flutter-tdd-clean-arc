import 'package:flutter/widgets.dart';

class StockModel {
  final String name;
  final String code;
  final double price;

  const StockModel(
      {@required this.name, @required this.code, @required this.price});

  factory StockModel.fromJson(Map json) {
    return StockModel(
        code: json['code'],
        name: json['name'],
        price: double.parse(json['price'] as String));
  }
}