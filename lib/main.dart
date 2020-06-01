import 'package:flutter/material.dart';
import 'todoListScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Flutter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TodoListScreen(title: 'Todo List'),
    );
  }
}
