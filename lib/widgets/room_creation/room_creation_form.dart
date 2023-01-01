import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../connector.dart' as connector;
import '../../model.dart';

class RoomCreationForm extends StatefulWidget {
  const RoomCreationForm({super.key});

  @override
  State<RoomCreationForm> createState() => _RoomCreationFormState();
}

class _RoomCreationFormState extends State<RoomCreationForm> {
  static final GlobalKey<FormState> _createRoomFormKey = GlobalKey<FormState>();

  late String _roomName;

  late String _roomDescription;

  bool _isPrivate = false;

  int _maxPeople = 25;

  @override
  Widget build(BuildContext context) {
    var maxPeopleSlider = ListTile(
      title: Row(
        children: [
          const Text('max\nPeople'),
          const SizedBox(width: 20),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
                showValueIndicator: ShowValueIndicator.always,
                valueIndicatorColor: appPrimaryColor,
                valueIndicatorTextStyle: appTextTheme.bodyText1),
            child: Slider(
              activeColor: Colors.black,
              inactiveColor: appPrimaryColor,
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
    );
    var isPrivateSwitcher = ListTile(
      title: Row(
        children: [
          const Text("Private"),
          const SizedBox(width: 20),
          Switch(
            activeColor: Colors.black,
            value: _isPrivate,
            onChanged: (value) {
              setState(() {
                _isPrivate = value;
              });
            },
          ),
        ],
      ),
    );
    var bottomButtons = Row(
      children: [
        TextButton(
          onPressed: () {
            FocusScope.of(context)
                .requestFocus(FocusNode()); //To hide the keyboard
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: appTextTheme.bodyText1!.copyWith(fontSize: 18),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.50,
        ),
        TextButton(
          onPressed: () {
            if (_createRoomFormKey.currentState!.validate()) {
              _createRoomFormKey.currentState!.save();
              connector.create(_roomName, _roomDescription, _isPrivate,
                  _maxPeople, model.userName, (inStatus, inRoomList) {
                if (inStatus == 'created') {
                  FocusScope.of(context).requestFocus(FocusNode());

                  model.setRoomList(inRoomList);
                  Navigator.of(context).pop();
                } else {
                  showBottomMessage(
                      context: context,
                      message: 'Sorry! This name is reserved.');
                }
              });
            }
          },
          child: Text(
            'Create',
            style: appTextTheme.bodyText1!.copyWith(fontSize: 18),
          ),
        ),
      ],
    );
    var roomNameField = TextFormField(
      decoration: const InputDecoration(
          icon: Icon(Icons.title), hintText: 'Type room Name here'),
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.length < 2 || value.length > 15) {
          return 'Room Title can not be \nless than 2 or more than 15 chars long';
        }
        return null;
      },
      onSaved: (newValue) {
        setState(() {
          _roomName = newValue!;
        });
      },
    );
    var roomDesField = TextFormField(
      decoration: const InputDecoration(
          icon: Icon(Icons.description), hintText: 'Describe it'),
      validator: (value) {
        return null;
      },
      onSaved: (newValue) {
        setState(() {
          _roomDescription = newValue!;
        });
      },
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _createRoomFormKey,
        child: Column(
          children: [
            roomNameField,
            const SizedBox(
              height: 20,
            ),
            roomDesField,
            const SizedBox(
              height: 20,
            ),
            maxPeopleSlider,
            const SizedBox(
              height: 20,
            ),
            isPrivateSwitcher,
            bottomButtons
          ],
        ),
      ),
    );
  }
}
