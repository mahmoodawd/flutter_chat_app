import 'package:flutter/material.dart';

import '../../model.dart';
import '../../connector.dart' as connector;
import '../../utils.dart';

class RoomItem extends StatelessWidget {
  final Map room;

  const RoomItem({
    super.key,
    required this.room,
  });

  @override
  Widget build(BuildContext context) {
    String roomName = room['roomName'];
    String roomDescription = room['description'];
    String roomCreator = room['creator'];
    bool isPrivate = room['private'];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      elevation: 10.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
          title: Text(roomName),
          subtitle: Text(roomDescription),
          leading: isPrivate
              ? Image.asset('assets/images/private_room_icon.png')
              : Image.asset('assets/images/public_room_icon.png'),
          onTap: () => onRoomItemTap(
                context,
                roomName,
                roomCreator,
                isPrivate,
              )),
    );
  }

  void onRoomItemTap(BuildContext context, String roomName, String roomCreator,
      bool isPrivate) {
    bool roomIsPrivate = isPrivate &&
        roomCreator != model.userName &&
        !model.roomInvites.containsKey(roomName);

    if (roomIsPrivate) {
      showBottomMessage(
          context: context,
          message:
              'Sorry!, you can not enter a private room without an invitation');
    } else {
      connector.join(roomName, model.userName, (inStatus, inRoomDescriptor) {
        if (inStatus == 'full') {
          showBottomMessage(
              context: context, message: 'Sorry!, This room is full');
        } else if (inStatus == 'joined') {
          isRoomMember(model.userName, model.currentRoomUserList)
              ? {
                  //Keep messages
                }
              : model.clearCurrentRoomMessages();

          pushUserIn(inRoomDescriptor['roomName'], inRoomDescriptor['users']);
          model.setCreatorFunctionsEnabled(
              inRoomDescriptor['creator'] == model.userName);

          Navigator.of(context).pushNamed('/Room');
        }
      });
    }
  }

  void pushUserIn(final String roomName, final Map roomUsers) {
    model
      ..setCurrentRoomName(roomName)
      ..setCurrentRoomUserList(roomUsers)
      ..setCurrentRoomEnabled(true);
  }
}
