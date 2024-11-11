import 'package:flutter/material.dart';
import 'package:group_project/story_setting.dart';

class LandingSceneDemo extends StatefulWidget {
  const LandingSceneDemo({super.key});

  @override
  _LandingSceneDemoState createState() => _LandingSceneDemoState();
}

class _LandingSceneDemoState extends State<LandingSceneDemo> {
  String selectedStoryTitle = "스토리를 선택하세요";
  String selectedStoryContent = "";
  List<Map<String, String>> stories = [];  
  
  void updateStory(String title, String content) {
    setState(() {
      selectedStoryTitle = title;
      selectedStoryContent = content;
      stories.add({
        "title": title,
        "content": content,
      });
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
          Expanded(
            flex: 2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedStoryTitle = stories[index]['title']!;
                      selectedStoryContent = stories[index]['content']!;
                    });
                  },
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        stories[index]['title']!,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
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
                    fit: BoxFit.fitHeight,
                    child: Container(
                      width: 400,
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
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
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


// LayoutDrawer 위젯
class LayoutDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(

    );
  }
}
