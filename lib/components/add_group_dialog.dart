import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_stepper/smart_stepper.dart';

import 'add_group_steps.dart';

class AddGroupDialog extends StatefulWidget {
  final GroupDetailsConstructor constructor;
  const AddGroupDialog({super.key, required this.constructor});

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  int _index = 0;
  int _maxStep = 1;

  late final List<Step> _steps = <Step>[
    Step(
      title: Text("instance"),
      state: (_index == 0) ? StepState.editing : StepState.complete,
      content: GroupForm(
        constructor: widget.constructor,
      ),
    ),
    Step(
      title: Text("account"),
      state: (_index == 2) ? StepState.editing : StepState.indexed,
      content: AccountForm(
        constructor: widget.constructor,
      ),
    ),
    Step(
        title: Text("Key"),
        state: (_index == 0)
            ? StepState.indexed
            : (_index == 1)
                ? StepState.editing
                : StepState.complete,
        content: KeyForm(
          constructor: widget.constructor,
        )),
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Add new group"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmartStepper(
            currentStep: _index + 1,
            totalSteps: _steps.length,
            onStepperTap: (int p1) {
              bool a = true;
              for (var s in _steps.slice(0, p1 - 1)) {
                if (!(s.content as FormContainer).validate()) a = false;
              }
              if (a) {
                setState(() {
                  _index = p1 - 1;
                });
              }
            },
          ),
          IndexedStack(
            index: _index,
            children: _steps.map((s) {
              return s.content;
            }).toList(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    if (_index > 0) {
                      setState(() {
                        _index -= 1;
                      });
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Text("cancel")),
              TextButton(onPressed: advance, child: Text("continue")),
            ],
          )
        ],
      ),
    );
  }

  void advance() {
    if (((_steps.elementAt(_index).content as FormContainer).validate())) {
      if (_index < _steps.length - 1) {
        setState(() {
          _index += 1;
        });
        _maxStep = max(_maxStep, _index + 1);
      } else {
        addGroup(widget.constructor.construct());
        Navigator.pop(context);
      }
    }
  }
}

Future<void> addGroup(GroupDetails details) async {
  var dir = Directory(
      "${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}groups${Platform.pathSeparator}${details.displayName}");
  if (await dir.exists()) {
    throw Exception("there's already a group by that name");
  }
  await dir.create();
  await File("${dir.path}${Platform.pathSeparator}details.json").writeAsString(jsonEncode(details.toJson()));
  await File("${dir.path}${Platform.pathSeparator}users.json").writeAsString(jsonEncode(List.empty()));
  // non modular part, hopefully can be removed soon
  await Directory("${dir.path}${Platform.pathSeparator}states").create();
  for (int i = 0; i<1;i++) {
    File("${dir.path}${Platform.pathSeparator}states${Platform.pathSeparator}$i").create(recursive: true);
  }
}
