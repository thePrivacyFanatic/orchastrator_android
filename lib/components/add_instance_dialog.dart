import 'package:flutter/material.dart';
import 'add_instance_steps.dart';
import 'package:smart_stepper/smart_stepper.dart';

class AddInstanceDialog extends StatefulWidget {
  const AddInstanceDialog({super.key});

  @override
  State<AddInstanceDialog> createState() => _AddInstanceDialogState();
}

class _AddInstanceDialogState extends State<AddInstanceDialog> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    List<Step> steps = <Step>[
      Step(
        title: Text("instance"),
        state: (_index == 0) ? StepState.editing : StepState.complete,
        content: instanceForm,
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

    return AlertDialog(
      title: Text("Add new instance"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SmartStepper(
            currentStep: _index + 1,
            totalSteps: steps.length,
            onStepperTap: (int p1) {
              setState(() {
                _index = p1;
              });
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
              TextButton(
                  onPressed: () {
                    if (_index < steps.length) {
                      if ((steps.elementAt(_index).content.key
                              as GlobalKey<FormState>)
                          .currentState
                          !.validate()) {
                        setState(() {
                          _index += 1;
                        });
                      }
                    }
                  },
                  child: Text("continue")),
            ],
          )
        ],
      ),
    );
  }
}
