import 'package:flutter/material.dart';
import 'main.dart';


class StorySetting extends StatefulWidget {
  const StorySetting({super.key});

  @override
  State<StorySetting> createState() => _StorySettingState();
}

class _StorySettingState extends State<StorySetting> {
  Story story = Story();

  final GlobalKey<FormState> _titleKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text("Story Setting"),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("  Title"),
              _titleField(),
              const Text("  Characters"),
              const SizedBox(height: 15.0),
              Expanded(child: _showCharacters()),
              const Text("  Backgrounds"),
              const SizedBox(height: 15.0),
              Expanded(child: _showBackgrounds()),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    TextButton(
                      onPressed: () => _checkTitle(context),
                      child: const Text("save")
                    ),
                    TextButton(
                      onPressed: (){},
                      child: const Text("cancel")
                    ),
                ],
            )
          ]
        )
    );
  }

  void _checkTitle(BuildContext context){
    if(_titleKey.currentState!.validate()){
      _titleKey.currentState!.save();
    }
  }

  Widget _titleField(){
    return Container(
      padding: const EdgeInsets.all(15.0),
      child: Form(
          key: _titleKey,
          child: TextFormField(
            onSaved: (input) => story.title = input!,
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

  void _addCharacter() async {
    if (story.characterList.length >= 3) {
      showDialog(
          context: context,
          builder: (BuildContext) {
            return const AlertDialog(
              title: Text("Error!"),
              content: Text("Characters cannot be over 3"),
            );
          });
      return;
    }else {
      final Character? ch = await showDialog(
          context: context,
          builder: (BuildContext) => AddCharacter(story: story, ch: Character())
      );
      if(ch != null){
        setState(() => story.characterList.add(ch));
      }
    }
  }

  void _editCh(Character ch) async{
    Character? tempCh = await showDialog(
        context: context,
        builder: (BuildContext) => AddCharacter(story: story, ch: ch)
    );
    if(tempCh != null){
      setState(() => ch = tempCh);
    }
  }

  Widget _showCharacters() {
    var widgets = story.characterList.map((ch) => chWidget(ch)).toList();
    widgets
        .add(IconButton(onPressed: _addCharacter, icon: const Icon(Icons.add)));
    return ListView(children: widgets);
  }

  Widget chWidget(Character ch) {
    return Container(
        padding: const EdgeInsets.all(5.0),
        child: ListTile(
          title: Text(ch.name),
          onTap: () {
            _editCh(ch);
          },
          trailing: IconButton(
            onPressed: () => setState(() => story.characterList.remove(ch)),
            icon: const Icon(Icons.delete),
          ),
        )
    );
  }

  void _addBackground() async {
    if (story.backgroundList.length >= 3) {
      showDialog(
          context: context,
          builder: (BuildContext) {
            return const AlertDialog(
              title: Text("Error!"),
              content: Text("Characters cannot be over 3"),
            );
          });
    }else {
      final String? bg = await showDialog(
          context: context,
          builder: (BuildContext) => AddBackground(story: story)
      );
      if(bg != null){
        setState(() => story.backgroundList.add(bg));
      }
    }
  }

  Widget _showBackgrounds() {
    var widgets = story.backgroundList.map((bg) => bgWidget(bg)).toList();
    widgets
        .add(
        IconButton(onPressed: _addBackground, icon: const Icon(Icons.add)));
    return ListView(children: widgets);
  }

  Widget bgWidget(String bg) {
    return ListTile(
        title: Text(bg),
        trailing: IconButton(
          onPressed: () => setState(() => story.backgroundList.remove(bg)),
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
  final GlobalKey<FormState> _tagKey = GlobalKey<FormState>();

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
            initialValue: widget.ch.name,
            onSaved: (input) => widget.ch.name = input!,
            validator: (input) {
              if(input!.isEmpty){
                return "Name cannot be empty";
              }
              if(input.length > 15){
                return "Name is too long";
              }
              for (Character tempCh in widget.story.characterList) {
                if (input == tempCh.name) {
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
      Navigator.pop(context, widget.ch);
    }
  }

  Widget _showTags() {
    var widgets = widget.ch.tags.map((tag) => _tagWidget(tag)).toList();
    widgets.add(
        IconButton(onPressed: () => _addTag(), icon: const Icon(Icons.add)));
    return ListView(children: widgets);
  }

  Widget _tagWidget(String tag) {
    return ListTile(
        title: Text(tag),
        trailing: IconButton(
          onPressed: () => setState(() {
            widget.ch.tags.remove(tag);
          }),
          icon: const Icon(Icons.delete),
        )
    );
  }

  void _addTag() {
    if (widget.ch.tags.length >= 5) {
      showDialog(
          context: context,
          builder: (BuildContext) => const AlertDialog(
            title: Text("Error!"),
            content: Text("Tags cannot be over 5"),
          )
      );
      return;
    }
    showDialog(
        context: context,
        builder: (BuildContext) => AlertDialog(
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
                              onPressed: () => _saveTag(context),
                              child: const Text("save")
                          ),
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("cancel")
                          ),
                        ]
                    )
                  ],
                )
            )
        )
    );
  }

  Widget _tagField() {
    return Form(
      key: _tagKey,
      child: TextFormField(
        onSaved: (input) => setState(() {
          widget.ch.tags.add(input!);
        }),
        validator: (input) {
          if (input!.isEmpty) {
            return "Tag cannot be empty";
          } else if (input.length > 15) {
            return "Tag is too long";
          } else if (widget.ch.tags.contains(input)) {
            return "Duplicate Tags not allowed";
          } else if (!_isFit(input)) {
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

  void _saveTag(BuildContext context) {
    if (_tagKey.currentState!.validate()) {
      _tagKey.currentState!.save();
      Navigator.pop(context);
    }
  }

  bool _isFit(String input) {
    return true;
  }
}


class AddBackground extends StatelessWidget {
  final Story story;
  final GlobalKey<FormState> _bgKey = GlobalKey<FormState>();
  late String bg;

  AddBackground({super.key, required this.story});

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
                          onPressed: () => _saveBg(context),
                          child: const Text("save")
                      ),
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("cancel")
                      ),
                    ])
              ],
            )
        )
    );
  }

  void _saveBg(BuildContext context) {
    if (_bgKey.currentState!.validate()) {
      _bgKey.currentState!.save();
      Navigator.pop(context, bg);
    }
  }

  Widget _bgField() {
    return Form(
      key: _bgKey,
      child: TextFormField(
        onSaved: (input) => bg = input!,
        validator: (input) {
          if (input!.isEmpty) {
            return "Tag cannot be Empty";
          } else if (input.length > 15) {
            return "Tag is too long";
          } else if (story.backgroundList.contains(input)) {
            return "Duplicate Tags not allowed";
          } else if (!_isFit(input)) {
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

  bool _isFit(String input) {
    return true;
  }

}
