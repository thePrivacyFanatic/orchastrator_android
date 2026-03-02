import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orchastrator/bindings.dart';
import 'package:orchastrator/objectives/objective.dart';


class EventList extends StatefulWidget implements Objective{
  final ObjectiveInput input;

  const EventList({super.key, required this.input});

  @override
  State<EventList> createState() => _EventListState();

  @override
  Objective load(ObjectiveInput input) => EventList(input: input);
}

class _EventListState extends State<EventList> {
  late List<Message> events = [];

  @override
  void initState() {
    super.initState();
    var state = widget.input.state.readAsStringSync();
    for (var e in (jsonDecode((state.isNotEmpty) ? state : "[]") as List)) {
      events.add(Message.fromJson(e));
    }
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
      children: [for (var m in events) Card(child: Text(m.toString()))],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.input.state.writeAsString(jsonEncode(events));
  }
}
