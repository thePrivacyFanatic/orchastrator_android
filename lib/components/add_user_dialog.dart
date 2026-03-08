import 'package:flutter/material.dart';
import 'package:orchastrator/bindings.dart';
import 'package:orchastrator/components/password_form_field.dart';

class AddUserDialog extends StatefulWidget {
  final Privilege privilege;
  const AddUserDialog({super.key, required this.privilege});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  String? username, password;
  Privilege? privilege;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add a new user"),
      content: Form(
          key: _formKey,
          child: SizedBox(
            height: 180,
            width: 300,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "username",
                    border: const OutlineInputBorder(),
                  ),
                  validator: (val) {
                    if (val == "") return "please type a username";
                    return null;
                  },
                  onSaved: (val) => username = val,
                ),
                SizedBox(height: 10,),
                PasswordFormField(
                  validator: (val) {
                    if (val == "") return "please type a password";
                    return null;
                  },
                  onSaved: (val) => password = val,
                ),
                SizedBox(height: 10,),
                DropdownMenuFormField<Privilege>(
                  label: const Text("permission"),
                  validator: (selection) =>
                      (selection == null) ? "please make a selection" : null,
                  dropdownMenuEntries: Privilege.menuEntries
                      .where((entry) => (entry.value > widget.privilege ||
                          widget.privilege == Privilege.admin))
                      .toList(),
                  onSaved: (val) => privilege = val!,
                ),
              ],
            ),
          )),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: const Text("cancel")),
        TextButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                _formKey.currentState?.save();
                Navigator.pop(context, {
                  "type": "user addition",
                  "username": username,
                  "privilege": privilege!.index,
                  "password": password
                });
              }
            },
            child: const Text("confirm"))
      ],
    );
  }
}
