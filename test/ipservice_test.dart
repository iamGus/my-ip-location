import 'package:flutter_test/flutter_test.dart';
import 'package:my_ip_location/Networking/ip_service.dart';
import 'package:my_ip_location/Networking/api_client.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  late Dio dio;
  late IPService ipService;
  late DioAdapter dioAdapter;

  setUp(() {
    dio = Dio();
    dioAdapter = DioAdapter(dio: dio);
    dio.httpClientAdapter = dioAdapter;
    ipService = IPService(ApiClient(dio: dio));
  });

  test('should return users current IP', () async {
    final mockData = '8.8.8.8';

    dioAdapter.onGet(
      'https://api.ipquery.io',
      (server) => server.reply(200, mockData),
    );

    final ipAddress = await ipService.fetchMyIP();

    expect(ipAddress, '8.8.8.8');
  });

  test('should throw exception when get current IP call fails', () async {
    dioAdapter.onGet(
      'https://api.ipquery.io',
      (server) => server.throws(
        404,
        DioException(
          requestOptions: RequestOptions(path: 'https://api.ipquery.io'),
          response: Response(
            statusCode: 404,
            requestOptions: RequestOptions(path: 'https://api.ipquery.io'),
          ),
        ),
      ),
    );

    expect(() => ipService.fetchMyIP(), throwsA(isA<Exception>()));
  });
}
