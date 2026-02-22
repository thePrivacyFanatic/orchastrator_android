import 'package:flutter/material.dart';

class ObjectiveLoader extends StatelessWidget {
  final Uri path;
  final Function(String message) send;
  const ObjectiveLoader(
      {super.key,
      required this.path,
      required this.send,});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Placeholder()
    );
  }
}
