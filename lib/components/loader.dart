import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eval/flutter_eval.dart';
import 'package:flutter_eval/security.dart';
import 'package:orchastrator/bindings.dart';
import 'package:orchastrator/eval_plugin.dart';
import 'package:path/path.dart';

class ObjectiveContainer extends StatefulWidget {
  final String path;
  final Stream<Message> receive;
  final StreamController out;
  final List<User> users;

  const ObjectiveContainer({
    super.key,
    required this.path,
    required this.receive,
    required this.out,
    required this.users,
  });

  @override
  State<ObjectiveContainer> createState() => _ObjectiveContainerState();
}

class _ObjectiveContainerState extends State<ObjectiveContainer> {
  late Widget child = RuntimeWidget(
    uri: Uri.parse("${widget.path}${Platform.pathSeparator}widget.evc"),
    library: "package:main.dart",
    function: "Objective.create",
    args: [
      ObjectiveInput(
          receiver: widget.receive,
          send: $Closure((runtime, target, args) {
            widget.out.add(
                jsonEncode({"oid": basename(widget.path), "content": args[0]}));
            return null;
          }),
          users: widget.users,
          state: File("${widget.path}${Platform.pathSeparator}state"))
    ],
    permissions: [
      FilesystemPermission.file("${widget.path}${Platform.pathSeparator}state")
    ],
    plugins: [OrchastratorPlugin()],
  );

  @override
  Widget build(BuildContext context) {
    return Card(child: child);
  }
}
