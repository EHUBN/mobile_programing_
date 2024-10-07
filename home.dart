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
                ListTile(title: Text("1")),
                ListTile(title: Text("2")),
                ListTile(title: Text("0"))
              ],
            ),
      bottomNavigationBar: TextButton(onPressed: (){}, child: Text("new")),
        );
  }
}
