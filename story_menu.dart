import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:group_project/saved_story.dart';
import 'package:group_project/story.dart';
import 'package:group_project/story_setting.dart';
import 'main.dart';

class StoryMenu extends StatefulWidget {
  const StoryMenu({super.key});

  @override
  _StoryMenuState createState() => _StoryMenuState();
}

class _StoryMenuState extends State<StoryMenu> {
  late final List<Story> _templates;
  late final List<StoryText> _savedStories;
  late Future _loading;

  @override
  void initState(){
    print('a');
    super.initState();
    _loading = _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story Menu"),
      ),
      body: FutureBuilder(
          future: _loading,
          builder: (context, snapShot){
            if (snapShot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    height: 300,
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _savedStories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => SavedStory(
                                  storyText: _savedStories[index]
                              ),
                            ),
                          ),
                          onLongPress: () {
                            setState(() => _savedStories.remove(_savedStories[index]));
                            _saveStories();
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.brown[400],
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(3, 3),
                                ),
                              ],
                              border: Border.all(
                                color: Colors.brown[600]!,
                                width: 2,
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Positioned(
                                  left: 5,
                                  right: 5,
                                  top: 5,
                                  bottom: 5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.brown[300]!,
                                          Colors.brown[500]!,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(_savedStories[index].title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black38,
                                            blurRadius: 4,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top:5.0),
                    height: 40,
                    child: const Text("Templates",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _templates.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () async {
                            Story? tempStory = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StorySetting(story: _templates[index]),
                              ),
                            );
                            if(tempStory != null) {
                              setState(() => _templates[index] = tempStory);
                              _saveTemplates();
                            }
                          },
                          onLongPress: () {
                            setState(() => askRemove(index));
                            _saveTemplates();
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title: ${_templates[index].title}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ..._templates[index].characterList.map((character) =>
                                  Row(
                                    children: [
                                      Text('Character: ${character.name}'),
                                    ],
                                  )
                              ),
                              ..._templates[index].backgroundList.map((bg) =>
                                  Row(
                                    children: [
                                      Text('Background: $bg'),
                                    ],
                                  )
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () async {
                              StoryText? text = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryPage(story: _templates[index],
                                  ),
                                ),
                              );
                              if(text != null) {
                                setState(() => _savedStories.add(text));
                                _saveStories();
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      onPressed: () async {
                        Story? tempStory = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StorySetting(story: Story()),
                          ),
                        );
                        if(tempStory != null) {
                          setState(() => _templates.add(tempStory));
                          _saveTemplates();
                        }
                      },
                      child: const Text("Make Story"),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
      ),
    );
  }

  void askRemove(int index)async{
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Do you want to delete?'),
            actions: [
              TextButton(
                  onPressed:(){
                    setState(() {
                      _templates.remove(_templates[index]);
                    });
                    Navigator.pop(context);
                  },
                  child: Text('yes')
              ),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child: Text('no')
              )
            ],
          );
        }
    );
  }

  Future<void> _saveTemplates() async {
    Directory? directory = await getDownloadsDirectory();
    File file = File("${directory!.path}/templates.json");
    List<dynamic>? jsonList = _templates;
    try {
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _saveStories() async {
    Directory? directory = await getDownloadsDirectory();
    File file = File("${directory!.path}/saved_stories.json");
    List<dynamic>? jsonList = _savedStories;
    try {
      await file.writeAsString(json.encode(jsonList));
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _loadFiles() async {
    print('b');
    Directory? directory = await getDownloadsDirectory();
    File templateFile = File("${directory!.path}/templates.json");
    bool isExist = await templateFile.exists();
    if (!isExist) {
      _templates = [];
    } else {
      try {
        String text = await templateFile.readAsString();
        List<dynamic> jsonList = json.decode(text);
        _templates = jsonList.map((story) =>
            Story.withParams(
              title: story['title'],
              length: story['length'],
              characterList: story['characters']
                  .map((ch) => Character.withParams(
                name: ch['name'],
                tags: ch['tags'].cast<String>(),
              )).toList().cast<Character>(),
              backgroundList: story['backgrounds'].cast<String>(),
            )).toList();
      } catch (e) {
        _templates = [];
        print("Error: $e");
      }
    }
    print('a');
    File savedStoryFile = File("${directory.path}/saved_stories.json");
    isExist = await savedStoryFile.exists();
    if (!isExist) {
      _savedStories = [];
    } else {
      try {
        String text = await savedStoryFile.readAsString();
        List<dynamic> jsonList = json.decode(text);
        _savedStories = jsonList.map((story) =>
            StoryText.withParams(
                title: story['title'],
                length: story['length'],
                story: story['story'].cast<String>()
            )).toList();
      } catch (e) {
        _savedStories = [];
        print("Error: $e");
      }
    }
  }
}