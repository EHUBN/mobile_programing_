import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class StoryPage extends StatefulWidget {
  final Story story;

  const StoryPage({super.key, required this.story});

  @override
  State<StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  final List<String> roleList = [];
  final List<String> historyList = [];
  late final int length;
  int page = 0;
  late String history;
  late String storyStr;
  late String characterStr;
  late String backgroundStr;
  late StoryText storyText;
  bool _isReady = false;
  bool _storyDone = false;

  @override
  void initState() {
    super.initState();
    length =  widget.story.length;
    storyText = StoryText(title: widget.story.title, length:length);

    for (int i = 0; i < length; ++i) {
      if (i == 0) {
        roleList.add("Make the beginning part of the story.");
      } else if (i == length - 1) {
        roleList.add("Make the ending part of the story which has no more options for user.");
      } else {
        roleList.add("Make the next part of the story, given the previous stories.");
      }
    }

    if(widget.story.characterList.isEmpty) {
      characterStr = '';
    } else {
      characterStr = 'Main Characters are ';
      for (Character ch in widget.story.characterList) {
        characterStr =
        "$characterStr'${ch.name}' whose attributes are '${ch.tags.join(
            ", ")}' and ";
      }
      characterStr = "${characterStr}it's all.";
    }

    if(widget.story.backgroundList.isEmpty){
      backgroundStr = '';
    } else {
      backgroundStr = "Background attributes of the stories are '${widget.story
          .backgroundList.join(", ")}'.";
    }

    _initStory();
  }

  Future <void> _initStory() async {
    setState(() => _isReady = false);
    late http.Response httpResponse;
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
    setState(() => _isReady = true);
  }

  void _nextStory(String choice) async {
    setState(() => _isReady = false);
    history = "$history The user's choice was $choice. ";
    historyList.add(history);
    late http.Response httpResponse;
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
    setState(() => _isReady = true);
    if(page >= length){
      historyList.add(history);
      storyText.story = historyList;
      setState(() => _storyDone = true);
    }
  }

  Future<http.Response> _makeStory(String role) {
    String historyStr = historyList.join(' ');

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
                "The previous stories were $historyStr. $role",
            },
            {
              "role": "system",
              "content":
                "You are a storyteller who creates interactive story, and the story you will create will be divided into parts. "
                "You should give three options to user about the main character's next action after each part, and continue the story given the context. "
                "$characterStr $backgroundStr Don't say any words without story.",
            },
          ]
        })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.story.title),
      ),
      body: !_isReady
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    width: double.infinity,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Text(storyStr,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _userButton(),
                ),
              ],
          ),
    );
  }

  Widget _userButton(){
    if(!_storyDone){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton(
            onPressed: () => _nextStory('A'),
            child: const Text('Option 1'),
          ),
          ElevatedButton(
            onPressed: () => _nextStory('B'),
            child: const Text('Option 2'),
          ),
          ElevatedButton(
            onPressed: () => _nextStory('C'),
            child: const Text('Option 3'),
          ),
        ],
      );
    } else {
      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
                onPressed: () => Navigator.pop(context, storyText),
                child: const Text("Save")
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel")
            ),
          ],
      );
    }
  }
}
