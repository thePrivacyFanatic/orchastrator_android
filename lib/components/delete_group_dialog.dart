import 'package:flutter/material.dart';

/// dialog for confirming group deletion
class DeleteGroupDialog extends StatelessWidget {
  const DeleteGroupDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete?"),
      content: const Text("just don't want you deleting it and having to go "
          "through the whole login process again but you do you"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text("Confirm")),
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text("Cancel")),
      ],
    );
  }
}
