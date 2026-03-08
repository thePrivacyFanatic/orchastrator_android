import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/components/add_group_dialog.dart';
import 'package:orchastrator/components/group_list.dart';
import 'package:orchastrator/pages/app_settings.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:path_provider/path_provider.dart';

import '../bindings.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var listKey = GlobalKey<GroupListState>();
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Saved Groups'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AppSettings()),
              );
            },
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            iconSize: 28,
            tooltip: 'app settings',
          ),
        ],
      ),
      body: GroupList(
        key: listKey,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          GroupDetails? details = await showDialog(
            context: context,
            builder: (context) => AddGroupDialog(),
          );
          if (details != null) {
            var dir = Directory(
                "${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}groups${Platform.pathSeparator}${details.displayName}");
            if (await dir.exists()) {
              throw Exception("there's already a group by that name");
            }
            await dir.create(recursive: true);
            File("${dir.path}${Platform.pathSeparator}details.json")
                .writeAsString(jsonEncode(details));
            File("${dir.path}${Platform.pathSeparator}users.json")
                .writeAsString(jsonEncode([
              systemUser
            ]));
            File("${dir.path}${Platform.pathSeparator}lastSid")
                .writeAsString("0");
            // non modular part, hopefully can be removed soon
            await Directory("${dir.path}${Platform.pathSeparator}states")
                .create();
            for (int i = 0; i < 2; i++) {
              File("${dir.path}${Platform.pathSeparator}states${Platform.pathSeparator}$i")
                  .create(recursive: true);
            }
            listKey.currentState?.addGroup(dir);
          }
        },
        tooltip: 'Add new group...',
        child: const Icon(Icons.add),
      ),
    );
  }
}
