// ignore: depend_on_referenced_packages
import "package:path/path.dart";

import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils.dart';
import '../../connector.dart' as connector;
import '../../model.dart';

class LoginForm extends StatelessWidget {
  static final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    late String userName;
    late String password;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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
              decoration: _buildLoginFieldsDecoration(
                  label: 'Usesrname', hint: 'Type username here'),
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
              decoration: _buildLoginFieldsDecoration(
                  label: 'Password', hint: 'Type password here'),
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
              padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
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
                          fontSize: 18, letterSpacing: 2, color: Colors.white),
                ),
                onPressed: () {
                  if (_loginFormKey.currentState!.validate()) {
                    _loginFormKey.currentState!.save();
                    _login(context, userName, password);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration _buildLoginFieldsDecoration(
      {required String label, required String hint}) {
    return InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        labelText: label,
        labelStyle: appTextTheme.bodyText1,
        hintText: hint);
  }

  _storeCredentials(final String inUserName, final String inPassowrd) async {
    var credentialsFile = File(join(model.docsDir.path, "credentials"));
    await credentialsFile.writeAsString('$inUserName============$inPassowrd');
  }

  _setGreetingBasedOnUserType(String userName, String validateStatus) {
    validateStatus == 'ok'
        ? model.setGreeting('Welcome Back $userName')
        : model.setGreeting('Welcome $userName to Fluter Chat ');
  }

  void _login(BuildContext context, String userName, String password) {
    connector.connectToServer(() {
      connector.validate(userName, password, (validateStatus) async {
        if (validateStatus == 'fail') {
          //When server replies with "fail" it means that either
          //password is incorrect or the usre is trying to access an existing account
          showBottomMessage(
              context: context, message: 'Check username and password!');
          connector.resetSocketConnection();
        } else {
          _storeCredentials(userName, password);
          model.setUserName(userName);
          _setGreetingBasedOnUserType(userName, validateStatus);
          FocusScope.of(context)
              .requestFocus(FocusNode()); //To hide the keyboard
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/',
            (route) => false,
          );
        }
      });
    });
  }
}
