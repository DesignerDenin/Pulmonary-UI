import 'package:flutter/material.dart';
import 'package:pulmonary/Utils/global.dart';
import 'package:pulmonary/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    apiURL = defaultURL;
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => const Home(),
      },
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        fontFamily: "Satoshi",
      ),
    );
  }
}
