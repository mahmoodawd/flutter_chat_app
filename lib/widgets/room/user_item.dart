import 'package:flutter/material.dart';

import '../../connector.dart' as connector;
import '../../model.dart';
import '../../utils.dart';

class UserItem extends StatelessWidget {
  final String userName;
  final String inviteOrKick;
  const UserItem(
      {super.key, required this.userName, required this.inviteOrKick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Image.asset('assets/images/user_avatar.png'),
        title: Text(
          userName,
          style: appTextTheme.bodyText1,
        ),
        onTap: () {
          if (inviteOrKick == 'invite') {
            connector.invite(userName, model.currentRoomName, model.userName,
                () {
              Navigator.of(context).pop();
              showBottomMessage(context: context, message: 'invitation Sent.');
            });
          } else {
            connector.kick(userName, model.currentRoomName, () {
              Navigator.of(context).pop();
            });
          }
        },
      ),
    );
  }
}
