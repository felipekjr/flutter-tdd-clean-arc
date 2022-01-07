import 'package:flutter_tdd/src/domain/helpers/helpers.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';

import 'package:flutter_tdd/src/data/models/models.dart';
import 'package:flutter_tdd/src/data/usecases/external_api_get_stock_price.dart';
import 'package:flutter_tdd/src/domain/entities/entities.dart';
import 'package:flutter_tdd/src/data/http/http.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {
  String url;
  HttpClient httpClient;
  GetStockPrice sut;

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientMock();
    sut = GetStockPrice(httpClient);
  });

  test('Should assure that the GetStockPrice passes correct values', () {
    //arrange
    when(httpClient.request(url)).thenAnswer((_) async => {
          'code': faker.lorem.word(),
          'name': faker.lorem.word(),
          'price': faker.randomGenerator.decimal().toString()
        });
    //act
    sut.get(url);

    //assert
    verify(httpClient.request(url));
  });

  test('Should assure that the GetStockPrice return correct value on 200',
      () async {
    final json = {
      'code': faker.lorem.word(),
      'name': faker.lorem.word(),
      'price': faker.randomGenerator.decimal().toString()
    };
    final modelRes = StockModel.fromJson(json);
    final expected = StockEntity(name: modelRes.name, price: modelRes.price);
    when(httpClient.request(url)).thenAnswer((_) async => json);

    final res = await sut.get(url);

    expect(res, expected);
  });

  test(
      'Should assure that the GetStockPrice throws unexpected when value is wrong',
      () async {
    when(httpClient.request(url)).thenAnswer(
        (_) async => {'price_less': faker.randomGenerator.decimal()});

    expect(sut.get(url), throwsA(DomainError.unexpected));
  });

  test(
      'Should assure that the GetStockPrice throws unexpected when internalError',
      () async {
    when(httpClient.request(url)).thenThrow(HttpError.internalError);

    expect(sut.get(url), throwsA(DomainError.unexpected));
  });

  test('Should assure that the GetStockPrice throws unexpected when badRequest',
      () async {
    when(httpClient.request(url)).thenThrow(HttpError.badRequest);

    expect(sut.get(url), throwsA(DomainError.unexpected));
  });

  test('Should assure that the GetStockPrice throws unexpected when notFound',
      () async {
    when(httpClient.request(url)).thenThrow(HttpError.notFound);

    expect(sut.get(url), throwsA(DomainError.unexpected));
  });

    test(
      'Should assure that the GetStockPrice throws unauthorized when unauthorized',
      () async {
    when(httpClient.request(url)).thenThrow(HttpError.unauthorized);

    expect(sut.get(url), throwsA(DomainError.unauthorized));
  });
}
