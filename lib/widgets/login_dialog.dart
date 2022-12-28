// ignore_for_file: prefer_const_constructors
// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables

import "package:path/path.dart";
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

import 'package:flutter/material.dart';

import '../connector.dart' as connector;
import '../model.dart' show FlutterChatModel, model;

class LoginDialog extends StatelessWidget {
  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
    String userName = '';
    String password = '';
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
          builder: (context, child, inModel) {
            return AlertDialog(
              content: SizedBox(
                width: 50,
                height: 250,
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: [
                      Text(
                        style: TextStyle(
                          color: Theme.of(model.rootBuildContext).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        'Enter your user name and password',
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'User Name',
                            hintText: 'Type User Name here'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.length < 3 || value.length > 10) {
                            return 'username can not be \nless than 3 or more than 10 chars long';
                          }
                          return null;
                        },
                        onSaved: (newValue) => userName = newValue!,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                            labelText: 'Password', hintText: 'Password here'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password field can not be blank';
                          }
                          return null;
                        },
                        onSaved: (newValue) => password = newValue!,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    if (_loginFormKey.currentState!.validate()) {
                      _loginFormKey.currentState!.save();
                      connector.connectToServer(() {
                        connector.validate(userName, password,
                            (validateStatus) async {
                          if (validateStatus == 'ok') {
                            storeCredentials(userName, password);
                            model.setUserName(userName);
                            Navigator.of(model.rootBuildContext).pop();
                            model.setGreeting('Welcome Back $userName');
                          }
                          if (validateStatus == 'fail') {
                            //When server replies with "fail" it means that either
                            //password is incorrect or the usre is trying to access an existing account
                            ScaffoldMessenger.of(model.rootBuildContext)
                                .showSnackBar(
                              SnackBar(
                                content: Text('Check username and password!'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            connector.resetSocketConnection();
                          }
                          if (validateStatus == 'created') {
                            storeCredentials(userName, password);
                            model.setUserName(userName);
                            Navigator.of(model.rootBuildContext).pop();
                            model.setGreeting(
                                'Welcome $userName to Fluter Chat ');
                          }
                        });
                      });
                    }
                  },
                  child: Text('Login'),
                ),
              ],
            );
          },
        ));
  }

  void validateWithStoredCredentials(
      final String inUserName, final String inPassword) {
    connector.connectToServer(() {
      connector.validate(inUserName, inPassword, (validateStatus) async {
        if (validateStatus == 'ok' || validateStatus == 'created') {
          model.setUserName(inUserName);
          model.setGreeting('Welcome Back $inUserName');
        }
        if (validateStatus == 'fail') {
          showDialog(
            context: model.rootBuildContext,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Validation failed!'),
                content: Text(
                    'It appears that the server has restarted and the username you last used was '
                    'subsequently taken by someone else.\n\nPlease re-start FlutterChat and choose a different username.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      var credentialsFile =
                          File(join(model.docsDir.path, "credentials"));
                      credentialsFile.deleteSync();
                    },
                    child: Text('ok'),
                  ),
                ],
              );
            },
          );
        }
      });
    });
  }

  void storeCredentials(
      final String inUserName, final String inPassowrd) async {
    var credentialsFile = File(join(model.docsDir.path, "credentials"));
    await credentialsFile.writeAsString('$inUserName============$inPassowrd');
  }
}
