import 'package:flutter/material.dart';
import 'make_story.dart';

class MyApp1 extends StatelessWidget {
  const MyApp1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Title'),
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(

            children: [
              Container(
                width: 700.0,
                height: 600.0,
                alignment: Alignment.center,

                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: Text(
                  'story text',
                ),
              ),
              SizedBox(height: 20.0),

              Column(

                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'option 1:',
                    ),
                  ),

                  SizedBox(height: 10.0),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'option 2:',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {

                    },
                    child: Text('option 1'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: Text('option 2'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}