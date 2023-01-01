import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/material.dart';

import '../widgets/login/login_form.dart';
import '../model.dart' show FlutterChatModel, model;

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return ScopedModel<FlutterChatModel>(
        model: model,
        child: ScopedModelDescendant<FlutterChatModel>(
            builder: (context, child, model) {
          return const Scaffold(
            body: LoginForm(),
          );
        }));
  }
}
