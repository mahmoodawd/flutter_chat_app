import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../model.dart';

class MessagesList extends StatefulWidget {
  const MessagesList({super.key});

  @override
  State<MessagesList> createState() => _MessagesListState();
}

class _MessagesListState extends State<MessagesList> {
  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
            builder: (context, child, model) {
          return Expanded(
            child: ListView.builder(
              itemCount: model.currentRoomMessages.length,
              itemBuilder: (inContext, index) {
                Map message = model.currentRoomMessages[index];
                return message['roomName'] == model.currentRoomName
                    ? Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        width: 120,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 12,
                        ),
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 8,
                        ),
                        child: ListTile(
                          title: Text(message['message']),
                          subtitle: Text(message['userName']),
                        ),
                      )
                    : Container();
              },
            ),
          );
        }));
  }
}
