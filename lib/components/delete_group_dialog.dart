import 'package:flutter/material.dart';

class DeleteGroupDialog extends StatelessWidget {
  final VoidCallback deleter;
  const DeleteGroupDialog({super.key, required this.deleter});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete?"),
      content: const Text("just don't want you deleting it and having to go "
          "through the whole login process again but you do you"),
      actions: [
        TextButton(
            onPressed: () {
              deleter();
              Navigator.pop(context);
            },
            child: const Text("Confirm")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel")),
      ],
    );
  }
}
