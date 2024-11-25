import 'package:flutter/material.dart';
import 'package:group_project/main.dart';

class SavedStory extends StatefulWidget {
  final StoryText storyText;
  const SavedStory({super.key, required this.storyText});

  @override
  State<SavedStory> createState() => _SavedStoryState();
}

class _SavedStoryState extends State<SavedStory> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storyText.title),
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
                  widget.storyText.story[page],
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
                TextButton(
                  onPressed: _backPage,
                  child: const Text("back"),
                ),
                TextButton(
                  onPressed: _nextPage,
                  child: const Text("next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _nextPage(){
    if(page >= widget.storyText.length - 1){
      return;
    } else {
      setState(() => page++);
    }
  }

  void _backPage(){
    if(page <= 0){
      return;
    } else {
      setState(() => page--);
    }
  }
}
