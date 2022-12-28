import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';
import '../connector.dart' as connector;
import '../widgets/app_drawer.dart';

class Lobby extends StatelessWidget {
  const Lobby({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
          builder: (context, child, model) {
        return Scaffold(
            appBar: AppBar(
              title: Text(
                'Lobby',
                style: Theme.of(model.rootBuildContext)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
            ),
            drawer: const AppDrawer(),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed('/CreateRoom');
              },
            ),
            body: model.roomList.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Icon(
                        Icons.question_mark_rounded,
                        size: 72,
                      ),
                      Center(
                        child: Text(
                          'No rooms yet! \n\n Click the lower-right button to create the first room',
                          textAlign: TextAlign.center,
                          style: Theme.of(model.rootBuildContext)
                              .textTheme
                              .headline1,
                        ),
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: model.roomList.length,
                    itemBuilder: (context, index) {
                      Map room = model.roomList[index];
                      String roomName = room['roomName'];
                      String roomDescription = room['description'];
                      bool isPrivate = room['private'];

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        elevation: 10.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(roomName),
                          subtitle: Text(roomDescription),
                          leading: isPrivate
                              ? Image.asset(
                                  'assets/images/private_room_icon.png')
                              : Image.asset(
                                  'assets/images/public_room_icon.png'),
                          onTap: () {
                            if (isPrivate &&
                                room['creator'] != model.userName &&
                                !model.roomInvites.containsKey(roomName)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      backgroundColor: Colors.red,
                                      duration: Duration(seconds: 2),
                                      content: Text(
                                          'Sorry!, you can not enter a private room without an invitation')));
                            } else {
                              connector.join(roomName, model.userName,
                                  (inStatus, inRoomDescriptor) {
                                if (inStatus == 'full') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          backgroundColor: Colors.red,
                                          duration: Duration(seconds: 2),
                                          content: Text(
                                              'Sorry!, This room is full')));
                                } else if (inStatus == 'joined') {
                                  isRoomMember(model.userName,
                                          model.currentRoomUserList)
                                      ? {}
                                      : model.clearCurrentRoomMessages();
                                  model
                                    ..setCurrentRoomName(
                                        inRoomDescriptor['roomName'])
                                    ..setCurrentRoomUserList(
                                        inRoomDescriptor['users'])
                                    ..setCurrentRoomEnabled(true);
                                  if (inRoomDescriptor['creator'] ==
                                      model.userName) {
                                    model.setCreatorFunctionsEnabled(true);
                                  } else {
                                    model.setCreatorFunctionsEnabled(false);
                                  }
                                  Navigator.of(context).pushNamed('/Room');
                                }
                              });
                            }
                          },
                        ),
                      );
                    },
                  ));
      }),
    );
  }
}

bool isRoomMember(final String inUser, final List userList) {
  for (Map user in userList) {
    if (user['userName'] == inUser) {
      return true;
    }
  }
  return false;
}
