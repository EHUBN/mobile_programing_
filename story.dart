import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'main.dart';

class StoryPage extends StatefulWidget {
  final Story story;
  final Function(Map<String, dynamic> Text) updatestoryText;

  const StoryPage({super.key, required this.story, required this.updatestoryText});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final List<Character> characterList = [
    Character()..name = "Mia"..tags = ["young", "girl", "strong"],
    Character()..name = "Max"..tags = ["evil", "smart"],
    Character()..name = "Ayano"..tags = ["friendly", "fat"],
  ];
  final List<String> backgroundList = ["future", "dystopia"];
  final List<String> roleList = [];
  final List<String> historyList = [];
  final length = 5;
  late http.Response httpResponse;
  late String history;
  int page = 0;
  String storyStr = '';

  late Map<String, dynamic> text;

  @override
  void initState() {
    super.initState();
    text = {'title': widget.story.title, 'story': ''};

    for (int i = 0; i < length; ++i) {
      if (i == 0) {
        roleList.add("Make the beginning part of the story.");
      } else if (i == length - 1) {
        roleList.add("Make the ending part of the story which has no more options for user.");
      } else {
        roleList.add("Make the next part of the story, given the previous stories.");
      }
    }
    _initStory();
  }

  _initStory() async {
    try {
      httpResponse = await _makeStory(roleList[page]);
    } catch (e) {
      print(e);
    }
    if (httpResponse.statusCode == 200) {
      try {
        var data = jsonDecode(httpResponse.body);
        String output = data['choices'][0]['message']['content'];
        history = output;
        setState(() => storyStr = output);
      } catch (e) {
        print(e);
      }
    } else {
      print(httpResponse.statusCode);
    }
    ++page;
  }

  void _nextStory(String choice) async {
    if (page == length) {
      return;
    }
    history = "${history} The user's choice was ${choice}. ";
    historyList.add(history);
    try {
      httpResponse = await _makeStory(roleList[page]);
    } catch (e) {
      print(e);
    }
    if (httpResponse.statusCode == 200) {
      try {
        var data = jsonDecode(httpResponse.body);
        String output = data['choices'][0]['message']['content'];
        history = output;
        setState(() => storyStr = output);
      } catch (e) {
        print(e);
      }
    } else {
      print(httpResponse.statusCode);
    }
    ++page;
  }

  Future<http.Response> _makeStory(String role) {
    String characterStr = 'Characters are ';
    for (Character ch in widget.story.characterList) {
      characterStr =
      "$characterStr'${ch.name}' whose attributes are '${ch.tags.join(", ")}' and ";
    }
    characterStr = "${characterStr}it's all.";
    String backgroundStr =
        "Background attributes of the stories are '${widget.story.backgroundList.join(", ")}'.";
    final historyStr = historyList.join(' ');

    return http.post(Uri.parse(uri),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "llama3-8b-8192",
          "messages": [
            {
              "role": "user",
              "content":
              "The previous stories were ${historyStr}. ${role}",
            },
            {
              "role": "system",
              "content":
              "You are a storyteller who creates short interactive fairy tales, and the fairy tale you will create will be divided into parts. "
                  "You should give two options to user about the main character's next action after each part, and continue the story given the context. "
                  "${characterStr} ${backgroundStr} Don't say any words without story.",
            },
          ]
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
      ),
      body: Column(
        children: [

          Expanded(
            child: Container(
              padding: EdgeInsets.all(15.0),
              width: double.infinity,
              alignment: Alignment.topCenter,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              child: SingleChildScrollView(
                child: Text(
                  storyStr,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _nextStory('A'),
                  child: Text('Option 1'),
                ),
                ElevatedButton(
                  onPressed: () => _nextStory('B'),
                  child: Text('Option 2'),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              onPressed: () {
                text['story'] = historyList;
                widget.updatestoryText(text);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ),
        ],
      ),
    );
  }
}
