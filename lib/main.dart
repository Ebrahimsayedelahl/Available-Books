import 'package:available_books/homePage.dart';
import 'package:flutter/material.dart';
import 'model.dart';
import 'sql.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Sql.instance.open();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
      HomePage(),
    );

  }
}








