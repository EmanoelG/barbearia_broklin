


import 'package:barbearia_adriano/source/splash_screnn/splash_screnn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barber Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.brown,
          scaffoldBackgroundColor: Colors.white.withAlpha(190)),
      home: SplashScreen(),
    );
  }
}
