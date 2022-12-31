import 'package:flutter/material.dart';

import '../../model.dart';
import '../../connector.dart' as connector;

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  late String _messageText;
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Expanded(
          child: TextField(
            style: const TextStyle(),
            controller: _messageController,
            onChanged: (value) {
              setState(() {
                _messageText = value;
              });
            },
            decoration: const InputDecoration(hintText: 'Say something...'),
          ),
        ),
        const Divider(indent: 5.0),
        IconButton(
          onPressed: () {
            connector.post(model.userName, model.currentRoomName, _messageText,
                (inStatus) {
              if (inStatus == 'ok') {
                setState(() {
                  model.addMessage(model.userName, _messageText);
                  _messageController.clear();
                });
              }
            });
          },
          icon: const Icon(
            Icons.send,
            size: 48,
            color: Colors.black,
          ),
        )
      ]),
    );
  }
}
