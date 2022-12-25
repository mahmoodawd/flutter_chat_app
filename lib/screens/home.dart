import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart' show FlutterChatModel, model;
import '../widgets/app_drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Flutter Chat'),
            ),
            drawer: const AppDrawer(),
            body: Center(child: Text(model.greeting)),
          );
        },
      ),
    );
  }
}
