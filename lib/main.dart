import 'package:flutter/material.dart';

import 'Apod.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nasa APOD',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: ApodPage(),
    );
  }
}
