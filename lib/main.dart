import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'story_menu.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(const MyApp());
  });
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
final random = Random();

Color getColor() {
  return Color.fromARGB(
    255,
    random.nextInt(50) + 150,
    random.nextInt(50) + 150,
    random.nextInt(50) + 150,
  );
}

class Story {
  String? title;
  int length = 3;
  final List<Character> characterList;
  final List<String> backgroundList;

  Story() : characterList = [], backgroundList = [];
  Story.withStory({required Story s}):
        title = s.title,
        length = s.length,
        characterList = List.from(s.characterList),
        backgroundList = List.from(s.backgroundList);

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
  late final List<String> tags;

  Character(): name = '', tags = [];
  Character.withCh({required Character ch}):
        name = ch.name,
        tags = List.from(ch.tags);
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
  late final String realTitle;
  late final Color bookColor;

  StoryText({required this.title, required this.length, required this.story, required this.realTitle});

  Map<String,dynamic> toJson() => <String, dynamic>{
    'realTitle': realTitle,
    "title": title,
    "length": length,
    "story": story,
  };
}
