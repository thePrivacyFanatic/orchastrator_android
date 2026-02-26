import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/components/delete_group_dialog.dart';
import 'package:path_provider/path_provider.dart';

import '../pages/group_page.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => _GroupListState();
}

class _GroupListState extends State<GroupList> {
  List<_GroupItem> groups = [];

  Future<List<_GroupItem>> _listGroups() async {
    List<_GroupItem> items = [];
    Directory groupsDir = Directory(
        "${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}groups");
    await groupsDir.list().forEach((dir) {
      if (dir is Directory) {
        var key = ValueKey(dir);
        items.add(_GroupItem(
          key: key,
          dir: dir,
          deleter: () {
            setState(() {
              groups.removeWhere((e) => e.key == key);
            });
            dir.delete(recursive: true);
          },
        ));
      }
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _listGroups(),
        builder: (context, items) {
          groups = items.data ?? [];
          return ListView(
            children: groups,
          );
        });
  }
}

class _GroupItem extends StatefulWidget {
  final Directory dir;
  final VoidCallback deleter;

  const _GroupItem({super.key, required this.dir, required this.deleter});

  @override
  State<_GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<_GroupItem> {

  late final GroupDetails details;

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).hoverColor,
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
        trailing: PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () => showDialog(
                        context: context,
                        builder: (context) => DeleteGroupDialog(
                          deleter: widget.deleter,
                        )),
                    child: Icon(Icons.delete))
              ];
            },
            icon: Icon(Icons.more_vert)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => GroupPage(
                      details: details,
                      groupDir: widget.dir.path,
                    )),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    details = GroupDetails.fromJson(jsonDecode(
        File("${widget.dir.path}${Platform.pathSeparator}details.json")
            .readAsStringSync()));
  }
}
