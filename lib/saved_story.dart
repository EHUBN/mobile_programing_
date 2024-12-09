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
        title: Text(widget.storyText.realTitle,
          style: const TextStyle(fontStyle: FontStyle.italic)
        ),
      ),
      body: Column(
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
                child: Text(
                  widget.storyText.story[page],
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _backPage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: const Center(
                        child: Text('back',
                            style:TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: _nextPage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
                      child: const Center(
                        child: Text('next',
                            style:TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold)
                        ),
                      ),
                    ),
                  ),
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
