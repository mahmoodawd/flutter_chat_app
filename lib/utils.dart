import 'package:flutter/material.dart';

import 'model.dart';

/// Show the please wait dialog.
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
} /* End showPleaseWait(). */

void hidePleaseWait() {
  Navigator.of(model.rootBuildContext).pop();
}