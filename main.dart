import 'package:flutter/material.dart';
import 'story_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Story Setting',
      home: StoryMenu(),
    );
  }
}

const apiKey = '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';
const uri = 'https://api.groq.com/openai/v1/chat/completions';

class Story {
  late String title;
  int length = 3;
  final List<Character> characterList;
  final List<String> backgroundList;

  Story() : title = '', characterList = [], backgroundList = [];
  Story.withParams({
    required this.title,
    required this.length,
    required this.characterList,
    required this.backgroundList
  });

  Map<String,dynamic> toJson() => <String, dynamic>{
    "title": title,
    "length": length,
    "characters": characterList,
    "backgrounds": backgroundList
  };
}

class Character {
  late String name;
  final List<String> tags;

  Character(): name = '', tags = [];
  Character.withParams({required this.name, required List<String> tags}):
        tags = List.from(tags);


  Map<String,dynamic> toJson() => <String, dynamic>{
    "name": name,
    "tags": tags,
  };
}

class StoryText {
  final String title;
  final int length;
  late final List<String> story;

  StoryText({required this.title, required this.length});
  StoryText.withParams({required this.title, required this.length, required this.story});

  Map<String,dynamic> toJson() => <String, dynamic>{
    "title": title,
    "length": length,
    "story": story,
  };
}





