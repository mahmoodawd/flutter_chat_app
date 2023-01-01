import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';
import '../utils.dart';
import '../widgets/shared/app_drawer.dart';

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (context, child, model) {
          return Scaffold(
              appBar: buildAppBar(pageTitle: 'Users in the server'),
              drawer: const AppDrawer(),
              body: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: model.userList.length,
                itemBuilder: (context, index) {
                  Map user = model.userList[index];
                  return Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: GridTile(
                      footer: Text(
                        user['userName'],
                        textAlign: TextAlign.center,
                        style: Theme.of(model.rootBuildContext)
                            .textTheme
                            .bodyText1,
                      ),
                      child: Image.asset('assets/images/user_avatar.png'),
                    ),
                  );
                },
              ));
        },
      ),
    );
  }
}
