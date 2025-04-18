import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:my_ip_location/Networking/ip_service.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() {
    return _LocationScreen();
  }
}

class _LocationScreen extends State<LocationScreen> {
  final IPService _ipService = IPService(null);
  TextEditingController _textController = TextEditingController();
  final MapController _mapController = MapController();
  bool _isLoading = false;

  @override
  void dispose() {
    _mapController.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _findLocation() async {
    final ipAddress = _textController.text;

    if (ipAddress.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Please enter an IP address')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final location = await _ipService.fetchMyLocation(ipAddress);
      _mapController.move(LatLng(location.lat, location.long), 13);
    } catch (e) {
      print('error $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sorry there was an error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _getCurrentIP() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final currentIP = await _ipService.fetchMyIP();
      _textController.text = currentIP;
    } catch (e) {
      print('error $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Sorry there was an error: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(title: Text('My IP Location')),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(child: TextField(controller: _textController)),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _findLocation,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text('Find location'),
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      onPressed: _getCurrentIP,
                      child: Text('What is my IP'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.my-ip-location.example',
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading) Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
