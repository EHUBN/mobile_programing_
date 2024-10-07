import 'package:flutter/material.dart';
import 'package:group_project/home.dart';
import 'package:group_project/make_story.dart';
import 'package:group_project/story_choice.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}




