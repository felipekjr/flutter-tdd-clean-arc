import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class StockEntity extends Equatable {
  final String name;
  final double price;

  const StockEntity({@required this.name, @required this.price});

  @override
  List<Object> get props => [name, price];

}