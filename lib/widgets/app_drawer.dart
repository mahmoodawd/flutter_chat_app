// ignore_for_file: depend_on_referenced_packages

import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import "../model.dart" show FlutterChatModel, model;
import '../connector.dart' as connector;
import 'login_dialog.dart';

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
            child: Column(children: [
              Container(
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
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  subtitle: Text(
                    model.currentRoomName,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Lobby'),
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
                height: 5,
              ),
              ListTile(
                enabled: model.currentRoomEnabled,
                title: const Text('Current room'),
                leading: const Icon(Icons.chat_rounded),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/Room', ModalRoute.withName('/'));
                },
              ),
              const SizedBox(
                height: 5,
              ),
              ListTile(
                title: const Text('Users'),
                leading: const Icon(Icons.people),
                onTap: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      '/UserList', ModalRoute.withName('/'));
                  connector.listUsers((inUserList) {
                    model.setUserList(inUserList);
                  });
                },
              ),
              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () async {
                  connector.resetSocketConnection();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', ModalRoute.withName('/'));
                  await showDialog(
                      context: model.rootBuildContext,
                      barrierDismissible: false,
                      builder: (inDialogContext) {
                        return const LoginDialog();
                      });
                },
              ),
            ]),
          );
        }));
  }
}
