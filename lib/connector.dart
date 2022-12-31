// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';

import 'dart:convert';

import 'package:flutter/material.dart';

import '../model.dart' show FlutterChatModel, model;
import 'utils.dart';

String serverUrl = 'http://192.168.1.2';
late SocketIO _io;

void connectToServer(final Function inCallBack) {
  _io = SocketIOManager().createSocketIO(serverUrl, '/', query: '',
      socketStatusCallback: (inData) {
    if (inData == 'connect') {
      _io.subscribe('newUser', newUser);
      _io.subscribe('created', created);
      _io.subscribe('closed', closed);
      _io.subscribe('joined', joined);
      _io.subscribe('left', left);
      _io.subscribe('kicked', kicked);
      _io.subscribe('invited', invited);
      _io.subscribe('posted', posted);
      inCallBack();
    }
  });
  // SocketIOManager().destroySocket(_io);
  // _io = SocketIOManager().createSocketIO(serverUrl, "/", query: "",
  //     socketStatusCallback: (inData) {
  //   print("## Connector.connectToServer(): callback: inData = $inData");
  //   if (inData == "connect") {
  //     print("## Connector.connectToServer(): callback: Connected to server");
  //     inCallBack();
  //   }
  // });

  _io.init();
  _io.connect();
}

void resetSocketConnection() {
  _io.unSubscribesAll();
  SocketIOManager().destroySocket(_io);
}

/*Server Bound Methods (To the server)*/
void validate(final String inUserName, final String inPassword,
    final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('validate',
      '{\'userName\' : \'$inUserName\', \'password\' : \'$inPassword\'}',
      (inData) {
    Map<String, dynamic> response = jsonDecode(inData);
    hidePleaseWait();
    inCallback(response['status']);
  });
}

void listRooms(final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('listRooms', '{}', (inData) {
    Map<String, dynamic> response = jsonDecode(inData);
    hidePleaseWait();
    inCallback(response);
  });
}

void create(
    final String inRoomName,
    final String inRoomDescription,
    final bool inPrivate,
    final int inMaxPeople,
    final String inCreator,
    final Function inCallback) {
  showPleaseWait();
  _io.sendMessage(
      'create',
      "{ \"roomName\" : \"$inRoomName\", \"description\" : \"$inRoomDescription\", "
          "\"maxPeople\" : $inMaxPeople, \"private\" : $inPrivate, \"creator\" : \"$inCreator\" }",
      (inData) {
    Map<String, dynamic> response = jsonDecode(inData);
    hidePleaseWait();
    inCallback(response['status'], response['rooms']);
  });
}

void join(final String inRoomName, final String inUserName,
    final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('join',
      '{\'userName\' : \'$inUserName\', \'roomName\' : \'$inRoomName\'}',
      (inData) {
    Map<String, dynamic> response = jsonDecode(inData);
    hidePleaseWait();
    inCallback(response['status'], response['room']);
  });
}

void leave(
    final String inRoomName, final inUserName, final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('leave',
      '{\'userName\' : \'$inUserName\', \'roomName\' : \'$inRoomName\'}',
      (inData) {
    hidePleaseWait();
    inCallback();
  });
}

void listUsers(final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('listUsers', '{}', (inData) {
    Map<String, dynamic> response = jsonDecode(inData);
    hidePleaseWait();
    inCallback(response);
  });
}

void invite(final String inUserName, final String inRoomName,
    String inInviterName, final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('invite',
      '{\'userName\' : \'$inUserName\', \'roomName\' : \'$inRoomName\', \'inviterName\' : \'$inInviterName\'}',
      (inData) {
    hidePleaseWait();
    inCallback();
  });
}

void post(final String inUserName, final String inRoomName, String inMessage,
    final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('post',
      '{\'userName\' : \'$inUserName\', \'roomName\' : \'$inRoomName\', \'message\' : \'$inMessage\'}',
      (inData) {
    Map<String, dynamic> response = jsonDecode(inData);
    hidePleaseWait();
    inCallback(response['status']);
  });
}

void close(final String inRoomName, final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('close', '{\'roomName\' : \'$inRoomName\'}', (inData) {
    hidePleaseWait();
    inCallback();
  });
}

void kick(final String inUserName, final String inRoomName,
    final Function inCallback) {
  showPleaseWait();
  _io.sendMessage('kick',
      '{\'userName\' : \'$inUserName\', \'roomName\' : \'$inRoomName\'}',
      (inData) {
    hidePleaseWait();
    inCallback();
  });
}

/*Client Bound Methods (from the server)*/

void newUser(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);

  model.setUserList(payload);
}

void created(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);

  model.setRoomList(payload);
}

void closed(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);

  model.setRoomList(payload);
  if (payload['roomName'] == model.currentRoomName) {
    model.setCurrentRoomUserList({});
    model.removeRoomInvite(payload['roomName']);
    model.setCurrentRoomName(FlutterChatModel.DEFAULT_ROOM_NAME);
    model.setCurrentRoomEnabled(false);
    model.setGreeting("This room is closed by the Creator.");
    Navigator.of(model.rootBuildContext)
        .pushNamedAndRemoveUntil('/', ModalRoute.withName("/"));
  }
}

void joined(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);

  if (model.currentRoomName == payload['roomName']) {
    model.setCurrentRoomUserList(payload['users']);
  }
}

void left(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);

  if (model.currentRoomName == payload['room']['roomName']) {
    model.setCurrentRoomUserList(payload['room']['users']);
  }
}

void kicked(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);

  model.removeRoomInvite(payload['roomName']);
  model.setCurrentRoomEnabled(false);
  model.setCurrentRoomUserList({});
  model.setCurrentRoomName(FlutterChatModel.DEFAULT_ROOM_NAME);
  model.setGreeting('opps! You\'re kicked out from this room');
  Navigator.of(model.rootBuildContext)
      .pushNamedAndRemoveUntil("/", ModalRoute.withName("/"));
}

void invited(inData) async {
  Map<String, dynamic> payload = jsonDecode(inData);
  String roomName = payload['roomName'];
  String inviterName = payload['inviterName'];

  model.addRoomInvite(roomName);
  showBottomMessage(
      context: model.rootBuildContext,
      message: 'You are invited to the room $roomName by $inviterName \n'
          'You can enter the room from the lobby');
}

void posted(inData) {
  Map<String, dynamic> payload = jsonDecode(inData);
  if (model.currentRoomName == payload['roomName']) {
    model.addMessage(payload['userName'], payload['message']);
  }
}
