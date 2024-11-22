import 'package:group_project/story_setting.dart';
import 'package:group_project/LayoutDrawer.dart';

import 'main.dart';

class LandingSceneDemo extends StatefulWidget {
  const LandingSceneDemo({super.key});

  @override
  _LandingSceneDemoState createState() => _LandingSceneDemoState();
}

class _LandingSceneDemoState extends State<LandingSceneDemo> {
  String selectedStoryTitle = "스토리를 선택하세요";
  String selectedStoryContent = "";
  List<Story> stories = [];
  List<Map<String, dynamic>> storyText = [];

  void updateStory(Story story) {
    setState(() {
      stories.add(story);
      selectedStoryTitle = story.title;
    });
  }

  void updatestoryText(Map<String, dynamic> text) {
    setState(() {
      storyText.add(text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Text Story"),
      ),
      drawer: LayoutDrawer(),
      body: Column(
        children: [
          SizedBox(
             height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: storyText.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStoryTitle = storyText[index]['title']!;
                      selectedStoryContent = storyText[index]['title']!;
                    });
                  },
                  child: Container(
                    width: 120,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.brown[400],
                      borderRadius: BorderRadius.circular(6),
                      boxShadow: [
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
                            child: Text(
                              stories[index].title,
                              style: TextStyle(
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
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedStoryTitle,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                FittedBox(
                  child: Container(
                    width: 400,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                    child: Text(
                      selectedStoryContent,
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 40,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "Templates",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
              ),
            )
          ),

          Expanded(
            child: ListView.builder(
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryPage(story: stories[index], updatestoryText: updatestoryText,
                        ),
                      ),
                    );
                  },
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Title: ${stories[index].title}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 8,),
                          ...stories[index].characterList.map((character) {
                            return Row(
                              children: [
                                Text('Character: ${character.name}'),
                                SizedBox(width: 8,),
                                Text('tag: ${character.tags.join(", ")}')
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      Text('Backgrounds: ${stories[index].backgroundList.join(", ")}'),
                    ],
                  ),
                );
              },
            ),
          ),


          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StorySetting(updateStory: updateStory),
                  ),
                );
              },
              child: Text("스토리 만들기"),
            ),
          ),
        ],
      ),
    );
  }
}
