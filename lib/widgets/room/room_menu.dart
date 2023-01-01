import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../../connector.dart' as connector;
import '../../model.dart';
import '../../utils.dart';
import '../room/user_item.dart';

class RoomMenu extends StatelessWidget {
  const RoomMenu({super.key});

  @override
  // ignore: avoid_renaming_method_parameters
  Widget build(BuildContext inContext) {
    return PopupMenuButton(
      onSelected: (selectedValue) {
        if (selectedValue == 'leave') {
          showConfirmationDialog(
              inContext, 'Are you really wanna leave', () => _leave(inContext));
        } else if (selectedValue == 'close') {
          showConfirmationDialog(inContext, 'Room will be lost, proceed?',
              () => _close(inContext));
        } else {
          _inviteOrKick(inContext, selectedValue);
        }
      },
      itemBuilder: (inContext) {
        return <PopupMenuEntry<String>>[
          const PopupMenuItem(
            value: 'leave',
            child: Text('Leave the room'),
          ),
          const PopupMenuItem(
            value: 'invite',
            child: Text('Invite someone'),
          ),
          const PopupMenuDivider(),
          PopupMenuItem(
            value: 'kick',
            enabled: model.creatorFunctionsEnabled,
            child: const Text('Kick a user'),
          ),
          PopupMenuItem(
            value: 'close',
            enabled: model.creatorFunctionsEnabled,
            child: const Text('Close the room'),
          ),
        ];
      },
    );
  }

  _inviteOrKick(final BuildContext inContext, final String inviteOrKick) {
    connector.listUsers((inUserList) {
      model.setUserList(inUserList);
      showDialog(
        context: inContext,
        builder: (inContext) {
          return ScopedModel<FlutterChatModel>(
              model: model,
              child: ScopedModelDescendant<FlutterChatModel>(
                builder: (inContext, child, model) {
                  var usersList = SizedBox(
                    width: double.maxFinite,
                    height: double.maxFinite / 2,
                    child: ListView.builder(
                      itemCount: inviteOrKick == 'invite'
                          ? model.userList.length
                          : model.currentRoomUserList.length,
                      itemBuilder: (inContext, index) {
                        Map user = inviteOrKick == 'invite'
                            ? model.userList[index]
                            : model.currentRoomUserList[index];
                        if (user["userName"] == model.userName ||
                            (isRoomMember(user["userName"],
                                    model.currentRoomUserList) &&
                                inviteOrKick == 'invite')) {
                          return Container();
                        }
                        return UserItem(
                          userName: user["userName"],
                          inviteOrKick: inviteOrKick,
                        );
                      },
                    ),
                  );

                  return AlertDialog(
                    title: Text(
                      'Select a user to $inviteOrKick',
                      style: appTextTheme.bodyText1,
                    ),
                    content: usersList,
                  );
                },
              ));
        },
      );
    });
  }

  _leave(final BuildContext inContext) {
    connector.leave(model.currentRoomName, model.userList, () {
      model
        ..removeRoomInvite(model.currentRoomName)
        ..setCurrentRoomUserList({})
        ..setCurrentRoomName(FlutterChatModel.DEFAULT_ROOM_NAME)
        ..setCurrentRoomEnabled(false);
      showBottomMessage(
          context: inContext, message: 'You Just left from the room');
      Navigator.of(inContext).pop();
      Navigator.of(inContext)
          .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
    });
  }

  _close(final BuildContext inContext) {
    connector.close(model.currentRoomName, () {
      model.setCurrentRoomEnabled(false);
      model.setCurrentRoomName(FlutterChatModel.DEFAULT_ROOM_NAME);
      Navigator.of(inContext).pop();
      Navigator.of(inContext)
          .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
    });
  }
}
