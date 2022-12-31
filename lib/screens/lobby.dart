import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';
import '../widgets/shared/app_drawer.dart';
import '../widgets/lobby/rooms_list.dart';

class Lobby extends StatelessWidget {
  const Lobby({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
      model: model,
      child: ScopedModelDescendant<FlutterChatModel>(
          builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Lobby',
              style: Theme.of(model.rootBuildContext)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 18, color: Colors.white),
            ),
          ),
          drawer: const AppDrawer(),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed('/CreateRoom');
            },
          ),
          body: model.roomList.isEmpty
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Icon(
                      Icons.question_mark_rounded,
                      size: 72,
                    ),
                    Center(
                      child: Text(
                        'No rooms yet! \n\n Click the lower-right button to create the first room',
                        textAlign: TextAlign.center,
                        style: Theme.of(model.rootBuildContext)
                            .textTheme
                            .headline1,
                      ),
                    ),
                  ],
                )
              : const RoomsList(),
        );
      }),
    );
  }
}
