
import '../models/models.dart';
import '../http/http.dart';
import '../../domain/entities/entities.dart';
import '../../domain/usecases/get_stock_price.dart';
import '../../domain/helpers/helpers.dart';

class GetStockPrice implements IGetStockPrice {
  final HttpClient client;

  const GetStockPrice(this.client);

  @override
  Future<StockEntity> get(String url) async {
    try {
      final res = StockModel.fromJson(await client.request(url));
      return StockEntity(name: res.name, price: res.price);
    } on HttpError catch (e) {
      throw e == HttpError.unauthorized
          ? DomainError.unauthorized
          : DomainError.unexpected;
    } catch (e) {
      throw DomainError.unexpected;
    }
  }
}