import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/prediction_screen.dart';
import 'screens/result_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Système de Routage',
      initialRoute: '/home',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      routes: {
        '/home': (context) => Splash(),
        '/predict': (context) => Predict()
      },
    );
  }
}
