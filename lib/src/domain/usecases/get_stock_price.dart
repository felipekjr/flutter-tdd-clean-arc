import '../entities/stock_entity.dart';

abstract class IGetStockPrice {
  Future<StockEntity> get(String url);
}
