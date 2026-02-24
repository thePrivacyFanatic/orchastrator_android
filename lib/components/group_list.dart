import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:path_provider/path_provider.dart';

import '../pages/group_page.dart';

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getApplicationDocumentsDirectory(),
        builder: (context, docDir) {
          if (docDir.data == null) return Center(child: CircularProgressIndicator());
          var groupDir =
              Directory("${docDir.data!.path}${Platform.pathSeparator}groups");
          if (!groupDir.existsSync()) groupDir.create();
          return ListView(children: [
            for (var group in groupDir.listSync())
              if (group is Directory) _GroupItem(dir: group)
          ]);
        });
  }
}

class _GroupItem extends StatelessWidget {
  final Directory dir;

  _GroupItem({required this.dir}) {
    details = GroupDetails.fromJson(jsonDecode(
        File("${dir.path}${Platform.pathSeparator}details.json")
            .readAsStringSync()));
  }

  late final GroupDetails details;

  @override
  Widget build(BuildContext context) {
    return Card.outlined(
      child: ListTile(
        leading: Text(
          '${details.displayName}@${details.relayURL}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        title: Text(
          details.username,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => GroupPage(
                      details: details,
                      groupDir: dir.path,
                    )),
          );
        },
      ),
    );
  }
}
