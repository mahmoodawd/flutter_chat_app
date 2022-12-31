import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';

import '../widgets/shared/app_drawer.dart';
import '../widgets/room/room_menu.dart';
import '../widgets/room/room_users_list.dart';
import '../widgets/room/messages_list.dart';
import '../widgets/room/new_message.dart';

class Room extends StatefulWidget {
  const Room({super.key});

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  @override
  Widget build(BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (inContext, child, model) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(
                model.currentRoomName,
                style: Theme.of(model.rootBuildContext)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
              actions: const [
                RoomMenu(),
              ],
            ),
            drawer: const AppDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: const [
                  RoomUsersList(),
                  MessagesList(),
                  NewMessage(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
