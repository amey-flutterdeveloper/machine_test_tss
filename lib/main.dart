import 'package:flutter/material.dart';
import 'package:machine_test_tss/task1/user_list_screen.dart';

import 'package:machine_test_tss/task3/to_do_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Machine Test TSS',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: UserListScreen()
    );
  }
}

