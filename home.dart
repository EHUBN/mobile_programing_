import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Library"),
        ),
        body:
            ListView(
              children: [
                ListTile(
                    title: Text("Story 1"),
                    subtitle: Text(
                        "character1, character2, ..." ,
                        style: Theme.of(context).textTheme.labelSmall
                    ),
                    trailing: Icon(Icons.play_arrow),
                ),
                ListTile(
                  title: Text("Story 2"),
                  subtitle: Text(
                      "character1, character2, ..." ,
                      style: Theme.of(context).textTheme.labelSmall
                  ),
                  trailing: Icon(Icons.play_arrow),
                ),
                ListTile(
                  title: Center(child: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.add),
                  ))
                )
              ],
            ),
        );
  }
}
