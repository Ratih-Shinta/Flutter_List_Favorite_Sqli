import 'package:flutter/material.dart';
import 'package:flutter_list_favorite_sqli/views/favorite_page_view.dart';
import 'package:flutter_list_favorite_sqli/views/home_page_view.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePageView()
    );
  }
}