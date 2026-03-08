import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/bindings.dart';

class EventList extends StatefulWidget {
  final ObjectiveInput input;

  const EventList({super.key, required this.input});

  @override
  State<EventList> createState() => _EventListState();

  @override
  const EventList.load(this.input, {super.key});
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
