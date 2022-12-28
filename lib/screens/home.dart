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
              title: Text(
                'Flutter Chat',
                style: Theme.of(model.rootBuildContext)
                    .textTheme
                    .bodyText1!
                    .copyWith(fontSize: 18, color: Colors.white),
              ),
            ),
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
                    style: Theme.of(model.rootBuildContext).textTheme.headline1,
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
