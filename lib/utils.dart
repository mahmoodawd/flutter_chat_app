import 'dart:io';

// ignore: depend_on_referenced_packages
import "package:path/path.dart";

import 'package:flutter/material.dart';

import 'model.dart';
import 'connector.dart' as connector;

var appPrimaryColor = Theme.of(model.rootBuildContext).primaryColor;
var appTextTheme = Theme.of(model.rootBuildContext).textTheme;

void showPleaseWait() {
  showDialog(
      context: model.rootBuildContext,
      barrierDismissible: false,
      builder: (BuildContext inDialogContext) {
        return Dialog(
            child: Container(
                width: 150,
                height: 150,
                alignment: AlignmentDirectional.center,
                decoration: BoxDecoration(color: Colors.blue[200]),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Center(
                          child: SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                  value: null, strokeWidth: 10))),
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          child: const Center(
                              child: Text("Please wait, contacting server...",
                                  style: TextStyle(color: Colors.white))))
                    ])));
      });
}

void hidePleaseWait() {
  Navigator.of(model.rootBuildContext).pop();
}

void validateWithStoredCredentials(
    final String inUserName, final String inPassword) {
  // Trigger connection to server.
  connector.connectToServer(() {
    // Ok, we're connected, now try to validate the user.
    connector.validate(inUserName, inPassword, (inStatus) {
      if (inStatus == "ok" || inStatus == "created") {
        model.setUserName(inUserName);
        model.setGreeting("Welcome back, $inUserName!");

        // If we get a fail back then the only possible cause is the server restarted and the username stored is
        // already taken.  In that case, we'll delete the credentials file and let the user know.
      } else if (inStatus == "fail") {
        // Alert user to the result.
        showDialog(
            context: model.rootBuildContext,
            barrierDismissible: false,
            builder: (final BuildContext inDialogContext) => AlertDialog(
                    title: const Text("Validation failed"),
                    content: const Text(
                        "It appears that the server has restarted and the username you last used was "
                        "subsequently taken by someone else.\n\nPlease re-start FlutterChat and choose a different username."),
                    actions: [
                      TextButton(
                          child: const Text("Ok"),
                          onPressed: () {
                            // Delete the credentials file.
                            var credentialsFile =
                                File(join(model.docsDir.path, "credentials"));
                            credentialsFile.deleteSync();
                            // Exit the app.
                            exit(0);
                          })
                    ]));
      }
    });
  });
}

bool isRoomMember(final String inUser, final List userList) {
  for (Map user in userList) {
    if (user['userName'] == inUser) {
      return true;
    }
  }
  return false;
}

void showBottomMessage({BuildContext? context, String? message}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      duration: const Duration(seconds: 2),
      content: Text(message!),
    ),
  );
}

void showConfirmationDialog(final BuildContext inContext, final String message,
    void Function() confirmAction) {
  showDialog(
    context: inContext,
    builder: (context) {
      return AlertDialog(
        content: Text(
          message,
          style: Theme.of(model.rootBuildContext).textTheme.bodyText1,
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('No')),
              const Divider(),
              TextButton(
                onPressed: confirmAction,
                child: const Text('Yes'),
              )
            ],
          )
        ],
      );
    },
  );
}

PreferredSizeWidget buildAppBar(
    {required String pageTitle, List<Widget>? actions}) {
  return AppBar(
    backgroundColor: appPrimaryColor,
    iconTheme: const IconThemeData(color: Colors.black),
    titleTextStyle: Theme.of(model.rootBuildContext)
        .textTheme
        .bodyText1!
        .copyWith(fontSize: 18, color: Colors.black),
    title: Text(
      pageTitle,
    ),
    actions: actions,
  );
}
