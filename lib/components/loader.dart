import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_eval/flutter_eval.dart';
import 'package:orchastrator_sdk/orchastrator_sdk.dart';

class ObjectiveLoader extends StatelessWidget {
  final Uri path;
  final Function(String message) send;
  const ObjectiveLoader(
      {super.key,
      required this.path,
      required this.send,});

  @override
  Widget build(BuildContext context) {
    StreamController<Signal> state = StreamController();
    final stateFile = File("$path${Platform.pathSeparator}savedState.txt");
    stateFile.readAsLines().then((lines) {
      for (var line in lines) {
        state.add(Signal.fromJson(jsonDecode(line)));
      }
      state.stream.listen((signal) {
        stateFile.writeAsStringSync(jsonEncode(signal) + Platform.lineTerminator, mode: FileMode.append);
      });
    });
    Widget objective;
    objective = RuntimeWidget(
      uri: Uri.file("file://$path${Platform.pathSeparator}objective.evc"),
      library: "package:objective/objective.dart",
      function: "Objective",
      args: [state],
      onError: _errorWidgetBuilder,
      loading: CircularProgressIndicator(
        semanticsLabel: "Loading objective...",
      ),
    );
    if (objective is! ObjectiveWidget) {
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
