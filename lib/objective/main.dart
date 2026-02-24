import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orchastrator/bindings.dart';


class Objective extends StatefulWidget {
  final ObjectiveInput input;

  const Objective({super.key, required this.input});

  @override
  State<Objective> createState() => _EventListState();
}

class _EventListState extends State<Objective> {
  late List<Message> events;

  @override
  void initState() {
    super.initState();
    events = jsonDecode(widget.input.state.readAsStringSync());
    widget.input.receiver.listen((msg) {
      if (msg.mtype == 1) {
        setState(() {
        events.add(msg);
      });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [for (var m in events) Text(m.toString())],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.input.state.writeAsStringSync(jsonEncode(events));
  }
}
