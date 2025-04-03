import 'package:my_ip_location/Networking/api_client.dart';

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
    return IPLocation(lat: 51.5072, long: 0.1276);
  }
}
