import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../model.dart';

import './room_item.dart';

class RoomsList extends StatelessWidget {
  const RoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
            builder: (context, child, model) {
          return ListView.builder(
            itemCount: model.roomList.length,
            itemBuilder: (context, index) {
              Map room = model.roomList[index];

              return RoomItem(room: room);
            },
          );
        }));
  }
}
