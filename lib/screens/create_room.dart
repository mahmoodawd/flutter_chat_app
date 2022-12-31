import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';

import '../widgets/room_creation/room_creation_form.dart';
import '../widgets/shared/app_drawer.dart';

class CreateRoom extends StatefulWidget {
  const CreateRoom({super.key});

  @override
  State<CreateRoom> createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
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
            body: const RoomCreationForm(),
          );
        },
      ),
    );
  }
}
