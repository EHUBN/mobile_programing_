
class LandingSceneDemo extends StatefulWidget {
  @override
  _LandingSceneDemoState createState() => _LandingSceneDemoState();
}

class _LandingSceneDemoState extends State<LandingSceneDemo> {
  String selectedStoryTitle = "스토리를 선택하세요";
  String selectedStoryContent = "";
  List<Map<String, String>> stories = [];

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
                        color: Colors.grey[200],
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
                setState(() {
                  int newStoryIndex = stories.length + 1;
                  stories.add({
                    "title": "Story $newStoryIndex",
                    "content": "내용 $newStoryIndex.", // 뒤에서 추가
                  });
                  selectedStoryTitle = "Story $newStoryIndex";
                  selectedStoryContent = "내용 $newStoryIndex."; // 추가 해야됨
                });
              },
              child: Text("스토리 만들기"),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_mark),
            label: 'Questions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}
