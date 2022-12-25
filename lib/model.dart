// ignore_for_file: non_constant_identifier_names
import 'dart:io';

import 'package:flutter/material.dart';
import "package:scoped_model/scoped_model.dart";

class FlutterChatModel extends Model {
  late BuildContext rootBuildContext;
  late Directory docsDir;
  String greeting = '';
  String userName = '';
// ignore: prefer_const_declarations
  static final String DEFAULT_ROOM_NAME = 'Not currently in a room';
  String currentRoomName = DEFAULT_ROOM_NAME;
  List currentRoomUserList = [];
  bool currentRoomEnabled = false;
  List currentRoomMessages = [];
  List roomList = [];
  List userList = [];
  bool creatorFunctionsEnabled = false;
  Map roomInvites = {};

  void setGreeting(final String inGreeting) {
    greeting = inGreeting;
    notifyListeners();
  }

  void setUserName(final String inUserName) {
    userName = inUserName;
    notifyListeners();
  }

  void setCurrentRoomName(final String inCurrentRoomName) {
    currentRoomName = inCurrentRoomName;
    notifyListeners();
  }

  void setCreatorFunctionsEnabled(final bool inEnabled) {
    creatorFunctionsEnabled = inEnabled;
    notifyListeners();
  }

  void setCurrentRoomEnabled(final bool inEnabled) {
    currentRoomEnabled = inEnabled;
    notifyListeners();
  }

  void addMessage(final String inUserName, final String inMessage) {
    currentRoomMessages.add({
      'userName': inUserName,
      'roomName': currentRoomName,
      'message': inMessage
    });
    notifyListeners();
  }

  void setRoomList(final Map inRoomList) {
    List rooms = [];
    for (String roomName in inRoomList.keys) {
      Map room = inRoomList[roomName];
      rooms.add(room);
    }
    roomList = rooms;
    notifyListeners();
  }

  void setUserList(final Map inUserList) {
    List users = [];
    for (String userName in inUserList.keys) {
      Map user = inUserList[userName];
      users.add(user);
    }
    userList = users;
    notifyListeners();
  }

  void setCurrentRoomUserList(Map inUserList) {
    List users = [];
    for (String userName in inUserList.keys) {
      Map user = inUserList[userName];
      users.add(user);
    }
    currentRoomUserList = users;
    notifyListeners();
  }

  void addRoomInvite(final String inRoomName) {
    roomInvites[inRoomName] = true;
    notifyListeners();
  }

  void removeRoomInvite(final String inRoomName) {
    roomInvites.remove(inRoomName);
    notifyListeners();
  }

  void clearCurrentRoomMessages() {
    currentRoomMessages = [];
    notifyListeners();
  }
}

FlutterChatModel model = FlutterChatModel();
