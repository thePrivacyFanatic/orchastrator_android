import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/connection_handler.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/components/loader.dart';
import 'package:orchastrator/pages/group_settings.dart';
import 'package:path/path.dart';

import '../bindings.dart';

class GroupPage extends StatefulWidget {
  final GroupDetails details;
  final String groupDir;

  const GroupPage({super.key, required this.details, required this.groupDir});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final Map<int, StreamController<Message>> streams = {};
  late final ConnectionHandler connection;
  late final List<User> users = jsonDecode(
      File("${widget.groupDir}${Platform.pathSeparator}users.json")
          .readAsStringSync());

  @override
  void initState() {
    super.initState();
    _connect();
  }

  Future<void> _connect() async {
    connection = await ConnectionHandler.fromGroup(widget.details);
    connection.internals.listen(_receive);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.details.displayName),
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
      body: FutureBuilder(
          future:
              Directory("${widget.groupDir}${Platform.pathSeparator}objectives")
                  .list()
                  .toList(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: [
                for (var objDir in asyncSnapshot.data!)
                  if (objDir is Directory) _subscribe(objDir, users)
              ],
            );
          }),
    );
  }

  void _receive(Message message) {
    if (message.mtype == 0) {
      var newContent = jsonDecode(message.content);
      message.content = newContent["content"];
      streams[newContent["oid"]]?.add(message);
    } else {
      _handleExternal(message);
      for (var stream in streams.values) {
        stream.add(message);
      }
    }
  }

  ObjectiveContainer _subscribe(Directory objDir, List<User> users) {
    StreamController<Message> receiver = StreamController();
    var oid = basename(objDir.path) as int;
    streams[oid] = receiver;
    StreamController<String> controller = StreamController();
    controller.stream.listen((message) {
      connection.send(jsonEncode({"oid": oid, "content": message}));
    });
    return ObjectiveContainer(
      path: objDir.path,
      receive: receiver.stream,
      out: controller,
      users: users,
    );
  }

  void _handleExternal(Message message) {
    var content = jsonDecode(message.content);
    switch (content["type"]) {
      case ("user addition"):
        users.add(User.fromJson(content["user"]));
      case ("perm"):
        users.firstWhere((user) {
          return user.uid == content["uid"];
        }).privilege = content["new"];
      case ("objective addition"):
        {
          var path =
              "${widget.groupDir}${Platform.pathSeparator}objectives${Platform.pathSeparator}${content["oid"]}";
          Directory(path).create();
          File("$path${Platform.pathSeparator}widget.evc")
              .writeAsBytesSync(utf8.encode(content["implementation"]));
          File("$path${Platform.pathSeparator}state").create();
        }

    }
  }

  @override
  void dispose() {
    super.dispose();
    File("${widget.groupDir}${Platform.pathSeparator}users.json")
        .writeAsStringSync(jsonEncode(users));
  }
}
