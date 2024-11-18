import 'package:flutter/material.dart';
import 'package:group_project/story.dart';
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
      home: StorySetting(updateStory: updateStory),
    );
  }
}

void updateStory(Story story) {}

const apiKey = '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';
const uri = 'https://api.groq.com/openai/v1/chat/completions';

class Story {
  String title = '';
  List<Character> characterList = [];
  List<String> backgroundList = [];
}

class Character {
  String name = '';
  List<String> tags = [];
  Character(){}
  Character.withParams(Character ch){
    this.name = ch.name;
    this.tags = List.from(ch.tags);
  }
}





