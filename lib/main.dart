import 'package:flutter/material.dart';
import 'package:my_ip_location/Screens/ip_location_screen.dart';

void main() {
  runApp(const MyIPLocation());
}

class MyIPLocation extends StatelessWidget {
  const MyIPLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My IP Location',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LocationScreen(),
    );
  }
}
