import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/components/delete_group_dialog.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../pages/group_page.dart';

/// widget handling loading the list of groups from the files
class GroupList extends StatefulWidget {
  const GroupList({super.key});

  @override
  State<GroupList> createState() => GroupListState();
}

class GroupListState extends State<GroupList> {
  final List<_GroupItem> _groups = [];

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
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        return _groups[index];
      },
    );
  }

  Future<void> addGroup(Directory dir) async {
    var key = ValueKey(dir);
    var item = _GroupItem(
        key: key,
        dir: dir,
        deleter: () {
          setState(() {
            _groups.removeWhere((group) => group.key == key);
          });
          dir.delete(recursive: true);
        });
    setState(() {
      _groups.add(item);
    });
  }
}

/// widget for individual group items
class _GroupItem extends StatefulWidget {
  final Directory dir;
  final VoidCallback deleter;

  const _GroupItem({super.key, required this.dir, required this.deleter});

  @override
  State<_GroupItem> createState() => _GroupItemState();
}

class _GroupItemState extends State<_GroupItem> {
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
                        .then((delete) => {if (delete == true) widget.deleter()}),
                    child: const ListTile(leading: Icon(Icons.delete), title: Text("delete"),))
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
