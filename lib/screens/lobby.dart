import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../model.dart';
import '../utils.dart';
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
          appBar: buildAppBar(pageTitle: 'Lobby'),
          drawer: const AppDrawer(),
          floatingActionButton: FloatingActionButton(
            backgroundColor: appPrimaryColor,
            child: const Icon(
              Icons.add,
              color: Colors.black,
              size: 36,
            ),
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
