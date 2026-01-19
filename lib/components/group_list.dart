import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/group_details.dart';

import '../pages/group_page.dart';

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        for (var group in Directory("").listSync())
          if (group is Directory) _fromFSEntity(group),
      ],
    );
  }
}

_GroupItem _fromFSEntity(FileSystemEntity dir) {
  GroupDetails details = GroupDetails.fromJson(
      jsonDecode(File("${dir.path}/details.json").readAsStringSync()));
  return _GroupItem(details: details);
}

class _GroupItem extends StatelessWidget {
  final GroupDetails details;
  const _GroupItem({required this.details});

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
              builder: (context) => GroupPage(details: details),
            ),
          );
        },
      ),
    );
  }
}

/*
          (context, index) =>  */
