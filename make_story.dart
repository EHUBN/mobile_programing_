import 'package:flutter/material.dart';

class StoryBuilder extends StatefulWidget {
  const StoryBuilder({super.key});

  @override
  State<StoryBuilder> createState() => _StoryBuilderState();
}

class _StoryBuilderState extends State<StoryBuilder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story Builder"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Story Length"),
          ),
          ListTile(
            title: Text("Ending"),
          ),
          ListTile(
            title: Text("Character"),
            trailing: Icon(Icons.add),
          ),
          ListTile(
            title: Text("BackGround"),
            trailing: Icon(Icons.add),
          )
        ],
      )
    );
  }
}
