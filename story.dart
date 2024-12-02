import 'dart:async';

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
    String? output;
    output = await _makeStory(roleList[page], null);
    if(output == null || output == 'back') {
      Navigator.pop(context);
    } else {
      history = output;
      setState(() {
        storyStr = output!;
        _isReady = true;
      });
      ++page;
    }
  }

  void _nextStory(String choice) async {
    setState(() => _isReady = false);
    String? output = await _makeStory(roleList[page], choice);
    if(output == null || output == 'retry') {
      setState(() => _isReady = true);
      return;
    } else if (output == 'back'){
      Navigator.pop(context);
      return;
    } else  {
      history = "$history The user's choice was $choice. ";
      historyList.add(history);
      history = output;
      setState(() {
        storyStr = output;
        _isReady = true;
      });
      ++page;
      if(page >= length){
        historyList.add(history);
        storyText.story = historyList;
        setState(() => _storyDone = true);
      }
    }
  }

  Future<String?> _makeStory(String role, String? choice) async {
    String historyStr = historyList.join(' ');

    if(choice != null) {
      String tempHistory = "$history The user's choice was $choice. ";
      historyStr = "$historyStr $tempHistory";
    }
    late http.Response httpResponse;
    try {
      httpResponse = await http.post(Uri.parse(uri),
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
      ).timeout(const Duration(seconds: 5),
          onTimeout: () => throw TimeoutException('timeout'));
    } catch (e) {
      late bool willRetry;
      if(choice == null) {
        willRetry =  await _firstTimeoutDialog() ?? false;
      } else {
        willRetry =  await _timeoutDialog() ?? false;
      }
      if(willRetry){
        return "retry";
      } else {
        return "back";
      }
    }
    if (httpResponse.statusCode == 200) {
      try {
        var data = jsonDecode(httpResponse.body);
        String output = data['choices'][0]['message']['content'];
        return output;
      } catch (e) {
        return null;
      }
    } else {
      print(httpResponse.statusCode);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if(didPop){
          return;
        }
        bool willPop = await _askPop(context) ?? false;
        if(willPop && context.mounted){
          Navigator.pop(context);
        }
      },
      child: Scaffold(
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
      ),
    );
  }

  Future<bool?> _askPop(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Do you want to go back?'),
            actions: [
              TextButton(
                  onPressed:(){
                    Navigator.pop(context, true);
                  },
                  child: const Text('yes')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context, false);
                  },
                  child: const Text('no')
              )
            ],
          );
        }
    );
  }

  Future<bool?> _timeoutDialog() {
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Check your WiFi Connection"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Retry")
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Go back to Home"),
              )
            ],
          );
        });
  }

  Future<bool?> _firstTimeoutDialog() {
    return showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text("Check your WiFi Connection"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Go back to Home"),
              )
            ],
          );
        });
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
              onPressed: () {
                storyName(context);
              },
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
  void storyName(BuildContext context) async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Write story name'),
          content: Form(
            child: TextFormField(
              onChanged: (value) {
                setState(() {
                  storyText.realTitle = value;
                });
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pop(context, storyText, );
              },
              child:Text('save'),
            ),
          ],
        );
      },
    );
  }
}
