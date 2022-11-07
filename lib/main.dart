import 'package:add_to_cart_animation/Screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Add to Cart Animation',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}