import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/components/delete_group_dialog.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../pages/group_page.dart';

class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  List<GroupItem> groups = [];

  @override
  void initState() {
    super.initState();
    loadGroups();
  }

  Future<void> loadGroups() async {
    Directory groupsDir = Directory(
        "${(await getApplicationDocumentsDirectory()).path}${Platform.pathSeparator}groups");
    groupsDir.list().forEach((dir) {
      if (dir is Directory) {
        addGroup(dir);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        return groups[index];
      },
    );
  }

  Future<void> addGroup(Directory dir) async {
    var key = ValueKey(dir);
    var item = GroupItem(
        key: key,
        dir: dir,
        deleter: () {
          setState(() {
            groups.removeWhere((group) => group.key == key);
          });
          dir.delete(recursive: true);
        });
    setState(() {
      groups.add(item);
    });
  }
}

class GroupItem extends StatefulWidget {
  final Directory dir;
  final VoidCallback deleter;

  const GroupItem({super.key, required this.dir, required this.deleter});

  @override
  State<GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<GroupItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).hoverColor,
      child: ListTile(
        title: Text(
          basename(widget.dir.path),
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        trailing: PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    onTap: () => showDialog(
                            context: context,
                            builder: (context) => DeleteGroupDialog())
                        .then((delete) => {if (delete) widget.deleter()}),
                    child: Icon(Icons.delete))
              ];
            },
            icon: Icon(Icons.more_vert)),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => GroupPage(
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
  }
}
