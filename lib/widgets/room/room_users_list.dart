import 'package:flutter/material.dart';
import 'package:flutter_chat/utils.dart';

import '../../model.dart';

class RoomUsersList extends StatefulWidget {
  const RoomUsersList({super.key});

  @override
  State<RoomUsersList> createState() => _RoomUsersListState();
}

class _RoomUsersListState extends State<RoomUsersList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: ExpansionPanelList(
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            _expanded = !_expanded;
          });
        },
        children: [
          ExpansionPanel(
            isExpanded: _expanded,
            headerBuilder: (inContext, isExpanded) => Text(
              'Users in the room',
              textAlign: _expanded ? TextAlign.center : TextAlign.start,
              style: appTextTheme.bodyText1,
            ),
            body: Builder(
              builder: (inContext) {
                List<Widget> roomUsers = [];
                for (var user in model.currentRoomUserList) {
                  roomUsers.add(Card(
                    elevation: 5,
                    margin: const EdgeInsets.only(left: 15, bottom: 10),
                    child: Column(
                      children: [
                        Image.asset('assets/images/user_avatar.png'),
                        Text(
                          user['userName'],
                          style: Theme.of(model.rootBuildContext)
                              .textTheme
                              .bodyText1,
                        ),
                      ],
                    ),
                  ));
                }
                return Row(
                  children: roomUsers,
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
