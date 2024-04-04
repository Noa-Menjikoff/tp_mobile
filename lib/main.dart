import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'BD/DatabaseHelper.dart';
import 'UI/homePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  DatabaseHelper.instance.database;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memory Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}
