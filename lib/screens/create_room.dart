import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';
import '../connector.dart' as connector;
import '../widgets/app_drawer.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  static final GlobalKey<FormState> _createRoomFormKey = GlobalKey<FormState>();
  late String _roomName;
  late String _roomDescription;
  bool _isPrivate = false;
  int _maxPeople = 25;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (context, child, model) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                'Create Room',
                style: Theme.of(model.rootBuildContext)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
            ),
            drawer: const AppDrawer(),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        if (_createRoomFormKey.currentState!.validate()) {
                          _createRoomFormKey.currentState!.save();
                          connector.create(
                              _roomName,
                              _roomDescription,
                              _isPrivate,
                              _maxPeople,
                              model.userName, (inStatus, inRoomList) {
                            if (inStatus == 'created') {
                              FocusScope.of(context).requestFocus(FocusNode());
                              Navigator.of(context).pop();
                              model.setRoomList(inRoomList);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      duration: Duration(seconds: 2),
                                      backgroundColor: Colors.red,
                                      content: Text(
                                          'Sorry! This room Name is reserved.')));
                            }
                          });
                        }
                      },
                      child: const Text(
                        'Create',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            body: Form(
              key: _createRoomFormKey,
              child: ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.title),
                        hintText: 'Type room Name here'),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value!.length < 2 || value.length > 15) {
                        return 'username can not be \nless than 2 or more than 15 chars long';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      setState(() {
                        _roomName = newValue!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        icon: Icon(Icons.description),
                        hintText: 'Type something about it'),
                    validator: (value) {
                      return null;
                    },
                    onSaved: (newValue) {
                      setState(() {
                        _roomDescription = newValue!;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        const Text('max\nPeople'),
                        const SizedBox(width: 20),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                              showValueIndicator: ShowValueIndicator.always,
                              valueIndicatorColor:
                                  Theme.of(context).primaryColor),
                          child: Slider(
                            label: '$_maxPeople',
                            value: _maxPeople.toDouble(),
                            min: 1.0,
                            max: 99.0,
                            onChanged: (value) {
                              setState(() {
                                _maxPeople = value.round();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    trailing: Text('$_maxPeople'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ListTile(
                    title: Row(
                      children: [
                        const Text("Private"),
                        const SizedBox(width: 20),
                        Switch(
                          value: _isPrivate,
                          onChanged: (value) {
                            setState(() {
                              _isPrivate = value;
                            });
                          },
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
