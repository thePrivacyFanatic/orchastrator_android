import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orchastrator/bindings.dart';
import 'package:orchastrator/classes/connection_handler.dart';
import 'package:orchastrator/components/add_user_dialog.dart';

class GroupSettings extends StatelessWidget {
  final ValueNotifier<User> me;
  final ConnectionHandler connection;
  final List<User> users;
  const GroupSettings(
      {super.key,
      required this.me,
      required this.connection,
      required this.users});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Column(
            children: [
              SizedBox(
                height: 500,
                child: Column(
                  children: [
                    if ((me.value.privilege) > Privilege.moderator)
                      TextButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) => AddUserDialog(
                                      privilege: me.value.privilege,
                                    )).then((message) {
                              if (message != null) {
                                connection.sendExt(jsonEncode(message));
                              }
                            });
                          },
                          child: const Text("Add a new user to the group")),
                    Expanded(
                        child: ListView.builder(
                            itemCount: users.length,
                            itemBuilder: (context, index) => UserTile(
                                  user: users[index],
                                  me: me,
                                  permChanger: (newPrivilege) {
                                    connection.sendExt(jsonEncode({
                                      "type": "perm",
                                      "uid": users[index].uid,
                                      "new": newPrivilege
                                    }));
                                  },
                                )))
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class UserTile extends StatelessWidget {
  final ValueNotifier<User> me;
  final User user;
  final void Function(Privilege) permChanger;

  const UserTile(
      {super.key,
      required this.user,
      required this.permChanger,
      required this.me});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text("${user.uid}"),
        title: Text(user.name),
        trailing: ((me.value.privilege == Privilege.admin ||
                    (me.value.privilege > user.privilege && me.value.privilege == Privilege.moderator)) &&
                !(user == me.value || user.uid == 0))
            ? DropdownMenu(
                dropdownMenuEntries: Privilege.menuEntries,
                initialSelection: user.privilege,
                onSelected: (selection) => permChanger(selection!),
              )
            : Text(user.privilege.name),
      ),
    );
  }
}
