import 'package:flutter/material.dart';
import 'package:group_project/story_setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Story Setting',
      home: StorySetting(),
    );
  }
}

class Story {
  String title = '';
  List<Character> characterList = [];
  List<String> backgroundList = [];
}

class Character {
  String name = '';
  List<String> tags = [];
}




