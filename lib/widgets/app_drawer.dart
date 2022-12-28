// ignore_for_file: depend_on_referenced_packages

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import "../model.dart" show FlutterChatModel, model;
import '../connector.dart' as connector;
import '../screens/login.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
            builder: (context, inChild, inModel) {
          return Drawer(
            width: MediaQuery.of(context).size.width * .70,
            child: Column(children: [
              Container(
                padding: const EdgeInsets.all(16),
                height: 100,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/drawer_background.jpg'),
                      fit: BoxFit.cover),
                ),
                child: ListTile(
                  title: Text(
                    model.userName,
                    textAlign: TextAlign.center,
                    style: Theme.of(model.rootBuildContext)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  subtitle: Text(
                    model.currentRoomName,
                    textAlign: TextAlign.center,
                    style: Theme.of(model.rootBuildContext)
                        .textTheme
                        .headline1!
                        .copyWith(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Lobby',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                leading: const Icon(Icons.list),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Lobby', ModalRoute.withName('/'));
                  connector.listRooms((inRoomList) {
                    model.setRoomList(inRoomList);
                  });
                },
              ),
              const SizedBox(
                height: 10,
                child: Divider(),
              ),
              ListTile(
                enabled: model.currentRoomEnabled,
                title: Text(
                  'Current room',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                leading: const Icon(Icons.chat_rounded),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Room', ModalRoute.withName('/'));
                },
              ),
              const SizedBox(
                height: 10,
                child: Divider(),
              ),
              ListTile(
                title: Text(
                  'Users',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                leading: const Icon(Icons.people),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/UserList', ModalRoute.withName('/'));
                  connector.listUsers((inUserList) {
                    model.setUserList(inUserList);
                  });
                },
              ),
              const SizedBox(
                height: 10,
                child: Divider(),
              ),
              ListTile(
                title: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                leading: const Icon(Icons.logout),
                onTap: () async {
                  connector.resetSocketConnection();
                  Navigator.push<void>(
                      model.rootBuildContext,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const Login()));
                },
              ),
            ]),
          );
        }));
  }
}
