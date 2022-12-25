import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';
import '../connector.dart' as connector;
import '../screens/lobby.dart';
import '../widgets/app_drawer.dart';

class Room extends StatefulWidget {
  const Room({super.key});

  @override
  State<Room> createState() => _RoomState();
}

class _RoomState extends State<Room> {
  bool _expanded = false;
  late String _messageText;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext inContext) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (inContext, child, model) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Text(model.currentRoomName),
              actions: [
                PopupMenuButton(
                  onSelected: (selectedValue) {
                    if (selectedValue == 'leave') {
                      connector.leave(model.currentRoomName, model.userList,
                          () {
                        model
                          ..removeRoomInvite(model.currentRoomName)
                          ..setCurrentRoomUserList({})
                          ..setCurrentRoomName(
                              FlutterChatModel.DEFAULT_ROOM_NAME)
                          ..setCurrentRoomEnabled(false);
                        ScaffoldMessenger.of(inContext).showSnackBar(
                            const SnackBar(
                                content: Text('You Just left from the room')));
                        Navigator.of(inContext).pushNamedAndRemoveUntil(
                            '/', ModalRoute.withName('/'));
                      });
                    } else if (selectedValue == 'close') {
                      connector.close(model.currentRoomName, () {
                        Navigator.of(inContext).pushNamedAndRemoveUntil(
                            '/', ModalRoute.withName('/'));
                        model.setCurrentRoomEnabled(false);
                        model.setCurrentRoomName(
                            FlutterChatModel.DEFAULT_ROOM_NAME);
                      });
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
                )
              ],
            ),
            drawer: const AppDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ExpansionPanelList(
                    expansionCallback: (panelIndex, isExpanded) {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    },
                    children: [
                      ExpansionPanel(
                        isExpanded: _expanded,
                        headerBuilder: (inContext, isExpanded) => const Text(
                          'Users in the room',
                        ),
                        body: Builder(
                          builder: (inContext) {
                            List<Widget> roomUsers = [];
                            for (var user in model.currentRoomUserList) {
                              roomUsers.add(Text(user['userName']));
                            }
                            return Column(
                              children: roomUsers,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: model.currentRoomMessages.length,
                      itemBuilder: (inContext, index) {
                        Map message = model.currentRoomMessages[index];
                        return message['roomName'] == model.currentRoomName
                            ? ListTile(
                                title: Text(message['message']),
                                subtitle: Text(message['userName']),
                              )
                            : Container();
                      },
                    ),
                  )
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 15,
                      width: MediaQuery.of(inContext).size.width * 0.75,
                      child: TextField(
                        controller: _messageController,
                        onChanged: (value) {
                          setState(() {
                            _messageText = value;
                          });
                        },
                        decoration:
                            const InputDecoration(hintText: 'Say something'),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          connector.post(model.userName, model.currentRoomName,
                              _messageText, (inStatus) {
                            if (inStatus == 'ok') {
                              model.addMessage(model.userName, _messageText);
                              _messageController.clear();
                              _scrollController.jumpTo(
                                  _scrollController.position.maxScrollExtent);
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.send,
                          size: 36,
                          color: Colors.cyan,
                        ))
                  ]),
            ),
          );
        },
      ),
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
                  return AlertDialog(
                    title: Text('Select a user to $inviteOrKick'),
                    content: SizedBox(
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
                          return Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListTile(
                              title: Text(
                                user['userName'],
                                style: const TextStyle(fontSize: 18),
                              ),
                              onTap: () {
                                if (inviteOrKick == 'invite') {
                                  connector.invite(
                                      user["userName"],
                                      model.currentRoomName,
                                      model.userName, () {
                                    Navigator.of(inContext).pop();
                                    ScaffoldMessenger.of(inContext)
                                        .showSnackBar(const SnackBar(
                                            content: Text('invition Sent ')));
                                  });
                                } else {
                                  connector.kick(
                                      user["userName"], model.currentRoomName,
                                      () {
                                    Navigator.of(inContext).pop();
                                  });
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ));
        },
      );
    });
  }
}
