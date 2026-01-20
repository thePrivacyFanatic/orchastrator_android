import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/components/loader.dart';
import 'package:orchastrator/pages/group_settings.dart';
import 'package:path/path.dart';

class GroupPage extends StatelessWidget {
  final GroupDetails details;
  final String groupDir;
  const GroupPage({super.key, required this.details, required this.groupDir});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(details.displayName),
        actions: [
          SizedBox(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GroupSettings(),
                  ),
                );
              },
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              iconSize: 28,
              tooltip: 'group settings',
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          for (var objDir
              in Directory("$groupDir${Platform.pathSeparator}objectives")
                  .listSync())
            ObjectiveLoader(
                path: objDir.uri,
                send: (message) {
                  throw UnimplementedError("attempted to send {\"oid\": ${basename(objDir.path)}, \"content\": \"$message\"}");
                })
        ],
      ),
    );
  }
}
