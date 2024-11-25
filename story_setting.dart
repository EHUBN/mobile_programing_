import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'main.dart';

class StorySetting extends StatefulWidget {
  final Story story;
  const StorySetting({super.key, required this.story});

  @override
  State<StorySetting> createState() => _StorySettingState();
}

class _StorySettingState extends State<StorySetting> {
  late int _storyLength;

  @override
  void initState(){
    super.initState();
    _storyLength = widget.story.length;
  }

  final GlobalKey<FormState> _titleKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Story Setting"),
        ),
        body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("  Title"),
                _titleField(),
                const SizedBox(height: 15.0),
                const Text("  Length of Story"),
                _radioButtons(),
                const SizedBox(height: 15.0),
                const SizedBox(height: 15.0),
                const Text("  Characters"),
                const SizedBox(height: 25.0),
                _showCharacters(),
                const Text("  Backgrounds"),
                const SizedBox(height: 25.0),
                _showBackgrounds(),
              ],
          ),
        ),
        bottomNavigationBar: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () => _checkTitle(context),
                child: const Text("save")
            ),
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("cancel")
            ),
          ],
        ),
    );
  }

  Widget _titleField(){
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Form(
          key: _titleKey,
          child: TextFormField(
            initialValue: widget.story.title,
            onSaved: (input) => widget.story.title = input!,
            validator: (input) {
              if(input!.isEmpty){
                return "Title cannot be empty";
              } else if(input.length > 40) {
                return "Title is too long";
              } else {
                return null;
              }
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder()
            ),
          )
      ),
    );
  }

  void _checkTitle(BuildContext context){
    if(_titleKey.currentState!.validate()){
      _titleKey.currentState!.save();
      widget.story.length = _storyLength;
      Navigator.pop(context, widget.story);
    }
  }

  Widget _radioButtons(){
    return Column(
      children: [
        RadioListTile<int>(
          value: 3,
          groupValue: _storyLength,
          title: const Text('3 Page'),
          onChanged: (int? value) {
            setState(() {
              _storyLength = value!;
            });
          },
        ),
        RadioListTile<int>(
          value: 5,
          groupValue: _storyLength,
          title: const Text('5 Page'),
          onChanged: (int? value) {
            setState(() {
              _storyLength = value!;
            });
          },
        ),
        RadioListTile<int>(
          value: 7,
          groupValue: _storyLength,
          title: const Text('7 Page'),
          onChanged: (int? value) {
            setState(() {
              _storyLength = value!;
            });
          },
        ),
      ],
    );
  }

  void _addCharacter() async {
    if (widget.story.characterList.length >= 3) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Error!"),
              content: Text("Characters cannot be over 3"),
            );
          });
      return;
    }else {
      final Character? tempCh = await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AddCharacter(story: widget.story, ch: Character())
      );
      if(tempCh != null){
        setState(() => widget.story.characterList.add(tempCh));
      }
    }
  }

  void _editCh(Character ch) async{
    Character? tempCh = await showDialog(
        context: context,
        builder: (context) => AddCharacter(story: widget.story, ch: ch)
    );
    if(tempCh != null){
      setState(() => ch = tempCh);
    }
  }

  Widget _showCharacters() {
    var widgets = widget.story.characterList.map((ch) => chWidget(ch)).toList();
    widgets.add(
        IconButton(
            onPressed: _addCharacter,
            icon: const Icon(Icons.add)
        )
    );
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: widgets
    );
  }

  Widget chWidget(Character ch) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          title: Text(ch.name),
          onTap: () => _editCh(ch),
          trailing: IconButton(
            onPressed: () => setState(() => widget.story.characterList.remove(ch)),
            icon: const Icon(Icons.delete),
          ),
        )
    );
  }

  void _addBackground() async {
    if (widget.story.backgroundList.length >= 3) {
      showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text("Error!"),
              content: Text("Characters cannot be over 3"),
            );
          });
    }else {
      final String? bg = await showDialog(
          context: context,
          builder: (context) => AddBackground(story: widget.story)
      );
      if(bg != null){
        setState(() => widget.story.backgroundList.add(bg));
      }
    }
  }

  Widget _showBackgrounds() {
    var widgets = widget.story.backgroundList.map((bg) => bgWidget(bg)).toList();
    widgets
        .add(
        IconButton(onPressed: _addBackground, icon: const Icon(Icons.add)));
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: widgets
    );
  }

  Widget bgWidget(String bg) {
    return ListTile(
        title: Text(bg),
        trailing: IconButton(
          onPressed: () => setState(() => widget.story.backgroundList.remove(bg)),
          icon: const Icon(Icons.delete),
        )
    );
  }
}

class AddCharacter extends StatefulWidget {
  final Story story;
  final Character ch;

  const AddCharacter({super.key, required this.story, required this.ch});

  @override
  State<AddCharacter> createState() => _AddCharacterState();
}

class _AddCharacterState extends State<AddCharacter> {
  final GlobalKey<FormState> _nameKey = GlobalKey<FormState>();
  late final Character tempCh;

  @override
  void initState(){
    super.initState();
    tempCh = Character.withParams(
        name: widget.ch.name,
        tags: widget.ch.tags
    );
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 500.0,
          child: Column(
            children: [
              const Text("Character's Name"),
              _nameField(),
              const Text("Features/Tags"),
              Expanded(child: _showTags()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                      onPressed: () => _saveName(context),
                      child: const Text("save")),
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("cancel")),
                ],
              )
            ],
          )),
    );
  }

  Widget _nameField() {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
          key: _nameKey,
          child: TextFormField(
            initialValue: tempCh.name,
            onSaved: (input) => tempCh.name = input!,
            validator: (input) {
              if(input!.isEmpty){
                return "Name cannot be empty";
              }
              if(input.length > 15){
                return "Name is too long";
              }
              if(input[0] != input[0].toUpperCase()){
                return "Name should start with upper case";
              }
              for (Character tempCh in widget.story.characterList) {
                if (input == widget.ch.name){
                  return null;
                } else if (input == tempCh.name) {
                  return "Same name are not allowed";
                }
              }
              return null;
            },
            decoration: const InputDecoration(
                border: OutlineInputBorder()
            ),
          )
      ),
    );
  }

  void _saveName(BuildContext context){
    if (_nameKey.currentState!.validate()) {
      _nameKey.currentState!.save();
      Navigator.pop(context, tempCh);
    }
  }

  Widget _showTags() {
    var widgets = tempCh.tags.map((tag) => _tagWidget(tag)).toList();
    widgets.add(
        IconButton(onPressed: () => _addTag(), icon: const Icon(Icons.add)));
    return ListView(children: widgets);
  }

  Widget _tagWidget(String tag) {
    return ListTile(
        title: Text(tag),
        trailing: IconButton(
          onPressed: () => setState(() {
            tempCh.tags.remove(tag);
          }),
          icon: const Icon(Icons.delete),
        )
    );
  }

  void _addTag() async {
    if (tempCh.tags.length >= 3) {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            title: Text("Error!"),
            content: Text("Tags cannot be over 3"),
          )
      );
      return;
    }
    String? tempTag = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AddTag(ch: tempCh)
    );
    if (tempTag != null){
      setState(() => tempCh.tags.add(tempTag));
    }
  }
}

class AddTag extends StatefulWidget {
  final Character ch;

  const AddTag({super.key, required this.ch});

  @override
  State<AddTag> createState() => _AddTagState();
}

class _AddTagState extends State<AddTag> {
  late String tempTag;
  bool _isFit = true;
  bool _buttonEnabled = true;

  final GlobalKey<FormState> _tagKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            child: Column(
              children: [
                const Text("Type a tag for your character"),
                _tagField(),
                const SizedBox(height: 5.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            if(_buttonEnabled){
                              _saveTag(context);
                            }
                          },
                          child: const Text("save")
                      ),
                      TextButton(
                          onPressed: () {
                            if(_buttonEnabled){
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("cancel")
                      ),
                    ]
                )
              ],
            )
        )
    );
  }

  Widget _tagField() {
    return Form(
      key: _tagKey,
      child: TextFormField(
        onSaved: (input) => Navigator.pop(context, input!),
        onChanged: (input) => tempTag = input,
        validator: (input) {
          if (input!.isEmpty) {
            return "Tag cannot be empty";
          } else if (input.length > 15) {
            return "Tag is too long";
          } else if (widget.ch.tags.contains(input)) {
            return "Duplicate Tags not allowed";
          } else if (!_isFit) {
            return "Choose more appropriate tag";
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
            helperText: "Llama will check your tag"
        ),
      ),
    );
  }

  Future<void> _saveTag(context) async {
    setState(() => _buttonEnabled = false);
    if (_tagKey.currentState!.validate()) {
      _isFit = await _aiCheck(tempTag);
      if(_tagKey.currentState!.validate()) {
        _tagKey.currentState!.save();
      }
      _isFit = true;
    }
    setState(() => _buttonEnabled = true);
  }

  Future<bool> _aiCheck(String input) async{
    late http.Response httpResponse;
    try {
      httpResponse = await http.post(Uri.parse(uri),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "model": "llama3-8b-8192",
            "messages": [
              {
                "role": "user",
                "content":  "Is word '$input' suitable for describing fictional story book's character?"
              },
              {
                "role": "system",
                "content": "You should only answer 'y' or 'n'."
              }
            ]
          })
      );
    } catch (e) {
      print(e);
    }
    if (httpResponse.statusCode == 200){
      try {
        var data = jsonDecode(httpResponse.body);
        String output = data['choices'][0]['message']['content'];
        print(output);
        if (output == 'y') {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
      }
    } else {
      print(httpResponse.statusCode);
    }
    return false;
  }
}


class AddBackground extends StatefulWidget {
  final Story story;

  const AddBackground({super.key, required this.story});

  @override
  State<AddBackground> createState() => _AddBackgroundState();
}

class _AddBackgroundState extends State<AddBackground> {
  late String tempBg;
  bool _isFit = true;
  bool _buttonEnabled = true;

  final GlobalKey<FormState> _bgKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 150.0,
            child: Column(
              children: [
                const Text("Type a tag for Background"),
                _bgField(),
                const SizedBox(height: 5.0),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            if(_buttonEnabled){
                              _saveBg(context);
                            }
                          },
                          child: const Text("save")
                      ),
                      TextButton(
                          onPressed: () {
                            if(_buttonEnabled){
                              Navigator.pop(context);
                            }
                          },
                          child: const Text("cancel")
                      ),
                    ])
              ],
            )
        )
    );
  }

  void _saveBg(context) async {
    setState(() => _buttonEnabled = false);
    if (_bgKey.currentState!.validate()) {
      _isFit = await _aiCheck(tempBg);
      if(_bgKey.currentState!.validate()) {
        _bgKey.currentState!.save();
      }
      _isFit = true;
    }
    setState(() => _buttonEnabled = true);
  }

  Widget _bgField() {
    return Form(
      key: _bgKey,
      child: TextFormField(
        onSaved: (input) => Navigator.pop(context, input!),
        onChanged: (input) => tempBg = input,
        validator: (input) {
          if (input!.isEmpty) {
            return "Tag cannot be Empty";
          } else if (input.length > 15) {
            return "Tag is too long";
          } else if (widget.story.backgroundList.contains(input)) {
            return "Duplicate Tags not allowed";
          } else if (!_isFit) {
            return "Choose more appropriate tag";
          } else {
            return null;
          }
        },
        decoration: const InputDecoration(
            helperText: "Llama will check your tag"
        ),
      ),
    );
  }

  Future<bool> _aiCheck(String input) async{
    late http.Response httpResponse;
    try {
      httpResponse = await http.post(Uri.parse(uri),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "model": "llama3-8b-8192",
            "messages": [
              {
                "role": "user",
                "content": "Is word '${input}' suitable for describing fictional story book's background "
              },
              {
                "role": "system",
                "content": "You should only answer 'y' or 'n'."
              }
            ]
          })
      );
    } catch (e) {
      print(e);
    }
    if (httpResponse.statusCode == 200){
      try {
        var data = jsonDecode(httpResponse.body);
        String output = data['choices'][0]['message']['content'];
        print(output);
        if (output == 'y') {
          return true;
        } else {
          return false;
        }
      } catch (e) {
        print(e);
      }
    } else {
      print(httpResponse.statusCode);
    }
    return false;
  }
}