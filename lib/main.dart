import 'package:flutter/material.dart';
import 'package:task1_rosenfield_health/Screens/servers_screen.dart';
import 'package:task1_rosenfield_health/Screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashAnimated());
  }
}