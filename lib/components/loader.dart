import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_eval/flutter_eval.dart';
import 'package:orchastrator_sdk/orchastrator_sdk.dart';
import 'package:path/path.dart';

class ObjectiveLoader extends StatelessWidget {
  final Directory data;
  final Function(String message) send;
  final String savedState;
  const ObjectiveLoader(
      {super.key,
      required this.data,
      required this.send,
      required this.savedState});

  @override
  Widget build(BuildContext context) {
    Widget objective;
    objective = RuntimeWidget(
      uri: Uri.file("file://${data.uri}/objective.evc"),
      library: "package:objective/objective.dart",
      function: "Objective",
      onError: _errorWidgetBuilder,
      loading: CircularProgressIndicator(
        semanticsLabel: "Loading objective...",
      ),
    );
    if (objective is Channel) {
      (objective as Channel).init(savedState, (String transaction) {
        send(jsonEncode({"oid": basename(data.path), "content": transaction}));
      });
    } else {
      objective = _errorWidgetBuilder(
          context,
          FormatException("Widget doesn't implement the Channel interface"),
          null);
    }
    return Card(
      child: objective,
    );
  }
}

Widget _errorWidgetBuilder(
        BuildContext context, Object error, StackTrace? stackTrace) =>
    Container(
        color: Colors.red,
        child: Column(children: [
          Text(error.toString()),
          Text(stackTrace?.toString() ?? "No stackTrace provided")
        ]));
