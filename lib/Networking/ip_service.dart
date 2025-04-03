class IPLocation {
  final double lat;
  final double long;

  IPLocation({required this.lat, required this.long});
}

class IPService {
  Future<String> fetchMyIP() async {
    return '1.1.1.1';
  }

  Future<IPLocation> fetchMyLocation(String ipAddress) async {
    return IPLocation(lat: 51.5072, long: 0.1276);
  }
}
