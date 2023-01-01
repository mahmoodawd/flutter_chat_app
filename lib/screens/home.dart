import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart' show FlutterChatModel, model;
import '../utils.dart';
import '../widgets/shared/app_drawer.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
        builder: (context, child, model) {
          return Scaffold(
            appBar: buildAppBar(pageTitle: 'Home'),
            drawer: const AppDrawer(),
            body: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.question_answer,
                    size: 100,
                  ),
                  Text(
                    model.greeting,
                    style: appTextTheme.headline1,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
