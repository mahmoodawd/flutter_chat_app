import 'package:flutter/material.dart';

import '../../model.dart';

import './room_item.dart';

class RoomsList extends StatelessWidget {
  const RoomsList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: model.roomList.length,
      itemBuilder: (context, index) {
        Map room = model.roomList[index];

        return RoomItem(room: room);
      },
    );
  }
}
