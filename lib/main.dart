import 'package:einkaufsliste/screens/main_reordable_screen.dart';
import 'package:einkaufsliste/screens/main_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Einkaufsliste',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      //home: MainScreen("Meine Einkaufsliste"),
      home: MainReordableScreen(),
    );
  }
}

