// ignore: depend_on_referenced_packages
import "package:path/path.dart";
import 'package:scoped_model/scoped_model.dart';

import 'dart:io';

import 'package:flutter/material.dart';

import '../utils.dart';

import '../connector.dart' as connector;
import '../model.dart' show FlutterChatModel, model;

class Login extends StatelessWidget {
  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    late String userName;
    late String password;
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
            builder: (context, child, model) {
          return Scaffold(
            body: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.question_answer,
                        size: 100,
                      ),
                      Text(
                        style: Theme.of(model.rootBuildContext)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 36),
                        textAlign: TextAlign.center,
                        'Enter your user name and password',
                      ),
                      const SizedBox(
                        height: 100,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            labelText: 'User name',
                            hintText: 'Type User name here'),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.length < 3 || value.length > 10) {
                            return 'user name can not be \nless than 3 or more than 10 chars long';
                          }
                          return null;
                        },
                        onSaved: (newValue) => userName = newValue!,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            labelText: 'Password',
                            hintText: 'Password here'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password field can not be blank';
                          }
                          return null;
                        },
                        onSaved: (newValue) => password = newValue!,
                      ),
                      const SizedBox(
                        height: 120,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 3, horizontal: 5),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextButton.icon(
                          icon: const Icon(
                            Icons.login,
                            color: Colors.white,
                            size: 26,
                          ),
                          label: Text(
                            'Login',
                            style: Theme.of(model.rootBuildContext)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 18,
                                    letterSpacing: 2,
                                    color: Colors.white),
                          ),
                          onPressed: () {
                            if (_loginFormKey.currentState!.validate()) {
                              _loginFormKey.currentState!.save();
                              connector.connectToServer(() {
                                connector.validate(userName, password,
                                    (validateStatus) async {
                                  if (validateStatus == 'ok') {
                                    storeCredentials(userName, password);
                                    model.setUserName(userName);
                                    model.setGreeting('Welcome Back $userName');
                                    Navigator.of(context)
                                        .popUntil(ModalRoute.withName('/'));
                                  }
                                  if (validateStatus == 'fail') {
                                    //When server replies with "fail" it means that either
                                    //password is incorrect or the usre is trying to access an existing account
                                    showBottomMessage(
                                        context: context,
                                        message:
                                            'Check username and password!');
                                    connector.resetSocketConnection();
                                  }
                                  if (validateStatus == 'created') {
                                    storeCredentials(userName, password);
                                    model.setUserName(userName);
                                    model.setGreeting(
                                        'Welcome $userName to Fluter Chat ');
                                    Navigator.of(context)
                                        .popUntil(ModalRoute.withName('/'));
                                  }
                                });
                              });
                            }
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        }));
  }

  void storeCredentials(
      final String inUserName, final String inPassowrd) async {
    var credentialsFile = File(join(model.docsDir.path, "credentials"));
    await credentialsFile.writeAsString('$inUserName============$inPassowrd');
  }
}
