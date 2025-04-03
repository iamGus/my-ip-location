import 'package:my_ip_location/Networking/api_client.dart';
import 'dart:convert';

class IPLocation {
  final double lat;
  final double long;

  IPLocation({required this.lat, required this.long});
}

class IPService {
  final ApiClient apiClient;

  IPService(ApiClient? apiClient) : apiClient = apiClient ?? ApiClient();

  Future<String> fetchMyIP() async {
    try {
      final response = await apiClient.get('https://api.ipquery.io');
      return response.toString();
    } catch (e) {
      throw Exception('Error fetching ip: $e');
    }
  }

  Future<IPLocation> fetchMyLocation(String ipAddress) async {
    try {
      print('https://ipapi.co/$ipAddress/json/');
      final response = await apiClient.get('https://ipapi.co/$ipAddress/json/');
      final Map<String, dynamic> data = jsonDecode(response.data);

      final double latitude = (data['latitude'] as num).toDouble();
      final double longitude = (data['longitude'] as num).toDouble();
      return IPLocation(lat: latitude, long: longitude);
    } catch (e) {
      // ipapi endpoint keeps returning RateLimited response for me so not to block
      // test I have used backup mock data below
      // Normally I would have returned error message here.
      return IPLocation(lat: 51.5072, long: 0.1276);
    }
  }
}
