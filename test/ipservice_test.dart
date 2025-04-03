import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_ip_location/Networking/ip_service.dart';
import 'package:my_ip_location/Networking/api_client.dart';
import 'package:dio/dio.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/mockito.dart';

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

  test('Should return users current IP', () async {
    final mockData = '8.8.8.8';

    dioAdapter.onGet(
      'https://api.ipquery.io',
      (server) => server.reply(200, mockData),
    );

    final ipAddress = await ipService.fetchMyIP();

    expect(ipAddress, '8.8.8.8');
  });
}
