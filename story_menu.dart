import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'saved_story.dart';
import 'story.dart';
import 'story_setting.dart';
import 'main.dart';
import 'dart:math';

final random = Random();
final colors = [
  Colors.brown,
  Colors.green,
  Colors.indigo,
  Colors.grey,
];

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
  void initState() {
    super.initState();
    _loading = _loadFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story Menu"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wallpaper.jpeg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.4),
              BlendMode.srcATop,
            ),
          ),
        ),
        child: FutureBuilder(
          future: _loading,
          builder: (context, snapShot) {
            if (snapShot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  Container(
                    height: 300,
                    margin: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                      border: Border.all(),
                      color: Colors.white.withOpacity(0.4),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _savedStories.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SavedStory(
                                storyText: _savedStories[index],
                              ),
                            ),
                          ),
                          onLongPress: () async {
                            bool willRemove = await _askRemove(context) ?? false;
                            if (willRemove) {
                              setState(() => _savedStories.remove(_savedStories[index]));
                              _saveStories();
                            }
                          },
                          child: Container(
                            width: 120,
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.brown[600],
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
                                          colors[random.nextInt(colors.length)][300]!,
                                          colors[random.nextInt(colors.length)][400]!,
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
                                      child: Column(
                                        children: [
                                          Text(
                                            _savedStories[index].realTitle ?? 'd',
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
                                          Text(_savedStories[index].title,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
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
                                        ],
                                      )
                                  ),
                                ),
                              ],
                            ),
                          )
                          ,
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    height: 40,
                    child: const Text("Templates",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
                                builder: (context) =>
                                    StorySetting(story: _templates[index]),
                              ),
                            );
                            if (tempStory != null) {
                              setState(() => _templates[index] = tempStory);
                              _saveTemplates();
                            }
                          },
                          onLongPress: () async {
                            bool willRemove = await _askRemove(context) ?? false;
                            if (willRemove) {
                              setState(() => _templates.remove(_templates[index]));
                              _saveTemplates();
                            }
                          },
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Title: ${_templates[index].title}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ..._templates[index].characterList.map((character) => Row(
                                children: [
                                  Text('Character: ${character.name}'),
                                ],
                              )),
                              ..._templates[index].backgroundList.map((bg) => Row(
                                children: [
                                  Text('Background: $bg'),
                                ],
                              )),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () async {
                              StoryText? text = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StoryPage(
                                    story: _templates[index],
                                  ),
                                ),
                              );
                              if (text != null) {
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
                        if (tempStory != null) {
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
          },
        ),
      ),
    );
  }

  Future<bool?> _askRemove(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Do you want to delete?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('yes')),
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('no'))
            ],
          );
        });
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
    Directory? directory = await getDownloadsDirectory();
    File templateFile = File("${directory!.path}/templates.json");
    bool isExist = await templateFile.exists();
    if (!isExist) {
      _templates = [];
    } else {
      try {
        String text = await templateFile.readAsString();
        List<dynamic> jsonList = json.decode(text);
        _templates = jsonList
            .map((story) => Story.withParams(
          title: story['title'],
          realTitle: story['realTitle'],
          length: story['length'],
          characterList: story['characters']
              .map((ch) => Character.withParams(
            name: ch['name'],
            tags: ch['tags'].cast<String>(),
          ))
              .toList()
              .cast<Character>(),
          backgroundList: story['backgrounds'].cast<String>(),
        ))
            .toList();
      } catch (e) {
        _templates = [];
        print("Error: $e");
      }
    }

    File savedStoryFile = File("${directory.path}/saved_stories.json");
    isExist = await savedStoryFile.exists();
    if (!isExist) {
      _savedStories = [];
    } else {
      try {
        String text = await savedStoryFile.readAsString();
        List<dynamic> jsonList = json.decode(text);
        _savedStories = jsonList
            .map((story) => StoryText.withParams(
          realTitle: story['realTitle'],
          title: story['title'],
          length: story['length'],
          story: story['story'].cast<String>(),
        ))
            .toList();
      } catch (e) {
        _savedStories = [];
        print("Error: $e");
      }
    }
  }
}
