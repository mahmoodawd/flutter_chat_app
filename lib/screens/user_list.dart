import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';
import '../widgets/app_drawer.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (context, child, model) {
          return Scaffold(
              appBar: AppBar(
                title: const Text('Users List'),
              ),
              drawer: const AppDrawer(),
              body: ListView.builder(
                itemCount: model.userList.length,
                itemBuilder: (context, index) {
                  Map user = model.userList[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListTile(
                      leading: Image.asset('assets/images/user_avatar.png'),
                      title: Text(user['userName']),
                    ),
                  );
                },
              ));
        },
      ),
    );
  }
}
