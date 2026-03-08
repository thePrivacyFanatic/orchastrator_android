import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:orchastrator/classes/group_details.dart';

import 'add_group_steps.dart';

class AddGroupDialog extends StatefulWidget {
  const AddGroupDialog({super.key});

  @override
  State<AddGroupDialog> createState() => _AddGroupDialogState();
}

class _AddGroupDialogState extends State<AddGroupDialog> {
  int _index = 0, _maxStep = 1;
  final TextEditingController urlController = TextEditingController(),
      gidController = TextEditingController(),
      nameController = TextEditingController(),
      passwordController = TextEditingController(),
      displayNameController = TextEditingController(),
      keyController = TextEditingController();

  late List<Widget> containers = [
    GroupForm(urlController: urlController, gidController: gidController),
    AccountForm(
        usernameController: nameController,
        passwordController: passwordController),
    KeyForm(nameController: displayNameController, keyController: keyController)
  ];

  late final List<Step> _steps = containers.map((form) {
    return Step(
        content: Form(key: GlobalKey<FormState>(), child: form),
        title: SizedBox.shrink());
  }).toList();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: (_index == 0),
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (result != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) => Navigator.pop(context, result));
          return;
        }
        setState(() {
          _index -= 1;
        });
        return;
      },
      child: AlertDialog(
        title: Text("Add new group"),
        content: SizedBox(
          width: 400,
          height: 400,
          child: Stepper(
            steps: _steps,
            type: StepperType.horizontal,
            onStepTapped: (int p1) {
              bool a = true;
              for (var s in _steps.slice(0, p1)) {
                if (!(s.content.key as GlobalKey<FormState>)
                    .currentState!
                    .validate()) {
                  a = false;
                }
              }
              if (a) {
                setState(() {
                  _index = p1;
                });
              }
            },
            currentStep: _index,
            onStepContinue: advance,
            onStepCancel: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  void advance() {
    if (((_steps.elementAt(_index).content.key as GlobalKey<FormState>)
        .currentState!
        .validate())) {
      if (_index < _steps.length - 1) {
        setState(() {
          _index += 1;
        });
        _maxStep = max(_maxStep, _index + 1);
      } else {
        Navigator.pop(
            context,
            GroupDetails(
                gid: gidController.text,
                displayName: displayNameController.text,
                relayURL: urlController.text,
                username: nameController.text,
                password: passwordController.text,
                aesKey: keyController.text));
      }
    }
  }
}
