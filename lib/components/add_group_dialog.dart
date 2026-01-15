import 'dart:math';

import 'package:flutter/material.dart';
import 'add_group_steps.dart';
import 'package:smart_stepper/smart_stepper.dart';

class AddGroupDialog extends StatefulWidget {
  const AddGroupDialog({super.key});

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  int _index = 0;
  int _maxStep = 1;

  late List<Step> steps = <Step>[
    Step(
      title: Text("instance"),
      state: (_index == 0) ? StepState.editing : StepState.complete,
      content: groupForm,
    ),
    Step(
      title: Text("account"),
      state: (_index == 2) ? StepState.editing : StepState.indexed,
      content: accountForm,
    ),
    Step(
        title: Text("Key"),
        state: (_index == 0)
            ? StepState.indexed
            : (_index == 1)
                ? StepState.editing
                : StepState.complete,
        content: keyForm),
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
            totalSteps: steps.length,
            onStepperTap: (int p1) {
              if (p1 <= _maxStep) {
                setState(() {
                  _index = p1 - 1;
                });
              } else if (p1 == _maxStep + 1) {
                advance();
              }
            },
          ),
          IndexedStack(
            index: _index,
            children: steps.map((s) {
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
    if (_index < steps.length) {
      if ((steps.elementAt(_index).content.key as GlobalKey<FormState>)
          .currentState!
          .validate()) {
        setState(() {
          _index += 1;
        });
        _maxStep = max(_maxStep, _index + 1);
      }
    }
  }
}
