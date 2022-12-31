// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import "package:path/path.dart";
import 'package:path_provider/path_provider.dart';
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

import 'package:flutter/material.dart';

import 'utils.dart';
import '../model.dart';
import '../screens/create_room.dart';
import '../screens/home.dart';
import '../screens/lobby.dart';
import '../screens/room.dart';
import '../screens/user_list.dart';
import '../screens/login.dart';

var credentials;
var credentialFileExists;

void main() {
  startMeUp() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory docsDir = await getApplicationDocumentsDirectory();
    model.docsDir = docsDir;
    var credentialsFile = File(join(model.docsDir.path, "credentials"));
    credentialFileExists = await credentialsFile.exists();
    if (credentialFileExists) {
      credentials = await credentialsFile.readAsString();
    }
    runApp(const FlutterChat());
  }

  startMeUp();
}

class FlutterChat extends StatelessWidget {
  const FlutterChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter chat',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        textTheme: const TextTheme(
          bodyText1: TextStyle(
            fontFamily: "BreeSerif",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          headline1: TextStyle(
              fontFamily: "Lobster", fontSize: 48, color: Colors.black),
        ),
      ),
      home: const FlutterChatMain(),
    );
  }
}

class FlutterChatMain extends StatelessWidget {
  const FlutterChatMain({super.key});

  @override
  Widget build(final BuildContext context) {
    model.rootBuildContext = context;
    WidgetsBinding.instance.addPostFrameCallback((_) => excuteAfterBuild());
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (context, child, inModel) {
            return MaterialApp(
                initialRoute: "/",
                routes: {
                  '/Login': (screenContext) => const Login(),
                  '/Lobby': (screenContext) => const Lobby(),
                  "/Room": (screenContext) => const Room(),
                  "/UserList": (screenContext) => const UserList(),
                  "/CreateRoom": (screenContext) => const CreateRoom()
                },
                home: const Home());
          },
        ));
  }

  Future<void> excuteAfterBuild() async {
    if (credentialFileExists) {
      List credParts = credentials.split('============');
      validateWithStoredCredentials(credParts[0], credParts[1]);
    } else {
      Navigator.push<void>(
          model.rootBuildContext,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const Login()));
    }
  }
}
