import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/connection_handler.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/objectives/eventlog.dart';
import 'package:orchastrator/pages/group_settings.dart';

import '../bindings.dart';
import '../objectives/chat.dart';

class GroupPage extends StatefulWidget {
  final String groupDir;

  const GroupPage({super.key, required this.groupDir});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  late final details = GroupDetails.fromJson(jsonDecode(
      File("${widget.groupDir}${Platform.pathSeparator}details.json")
          .readAsStringSync()));
  final Map<int, StreamController<Message>> streams = {};
  ConnectionHandler? connection;
  // nonmodualr but will require more replacement
  final List<User> users = List<User>.empty(growable: true);
  final List<Widget> containers = List<Widget>.empty(growable: true);
  late final int privilege;
  late int lastSid = int.parse(
      File("${widget.groupDir}${Platform.pathSeparator}lastSid")
          .readAsStringSync());

  @override
  void initState() {
    super.initState();
    containers.add(EventList(input: _subscribe(0, users)));
    containers.add(Chat(input: _subscribe(1, users)));
    for (var str in (jsonDecode(
        File("${widget.groupDir}${Platform.pathSeparator}users.json")
            .readAsStringSync()) as List)) {
      var user = User.fromJson(str);
      users.add(user);
      if (user.name == details.username) {
        privilege = user.privilege;
      }
    }
  }

  Future<void> _connect() async {
    connection = await ConnectionHandler.fromGroup(details, lastSid);
    connection!.received.listen(_receive);
  }

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
                    builder: (context) => GroupSettings(
                      privilege: privilege,
                    ),
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
          future: _connect(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasError) {
              if (asyncSnapshot.error is IOException) {
                return Center(
                  child: Card(
                      child: Column(
                    children: [
                      const Text(
                        "we could not connect to the server :(",
                      ),
                      const Text("here is the error message:"),
                      Text(asyncSnapshot.error.toString())
                    ],
                  )),
                );
              }
              if (asyncSnapshot.error == Exception("login fail")) {
                return Center(
                  child: Text("could not log into account :("),
                );
              }
              if (asyncSnapshot.error is FlutterError) {
                return Center(
                  child: ErrorWidget.withDetails(
                    error: asyncSnapshot.error as FlutterError,
                  ),
                );
              }
            }
            if (asyncSnapshot.connectionState == ConnectionState.done) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 500,
                    child: Card(child: containers[index]),
                  );
                },
                itemCount: containers.length,
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }

  void _receive(Message message) {
    lastSid++;
    if (message.mtype == 0) {
      var newContent = jsonDecode(message.content);
      message.content = newContent["content"];
      streams[newContent["oid"]]?.add(message);
    } else {
      _handleExternal(message);
    }
  }

  ObjectiveInput _subscribe(int oid, List<User> users) {
    StreamController<Message> receiver = StreamController();
    streams[oid] = receiver;
    StreamController<String> controller = StreamController();
    controller.stream.listen((message) {
      connection!.send(jsonEncode({"oid": oid, "content": message}));
    });
    return ObjectiveInput(
        receiver: receiver.stream,
        send: (msg) {
          controller.add(msg);
        },
        users: users,
        state: File(
            "${widget.groupDir}${Platform.pathSeparator}states${Platform.pathSeparator}$oid"));
  }

  void broadcast(Message message) {
    for (var stream in streams.values) {
      stream.add(message);
    }
  }

  void _handleExternal(Message message) {
    var content = jsonDecode(message.content);
    switch (content["type"]) {
      case ("user addition"):
        var user = User.fromJson(content["user"]);
        users.add(user);
        broadcast(message);
        if (user.name == details.username) {
          privilege = user.privilege;
        }
      case ("perm"):
        users.firstWhere((user) {
          return user.uid == content["uid"];
        }).privilege = content["new"];
        broadcast(message);
      // case ("objective addition"):
      //   {
      //     var path =
      //         "${widget.groupDir}${Platform.pathSeparator}objectives${Platform.pathSeparator}${content["oid"]}";
      //     Directory(path).create();
      //     File("$path${Platform.pathSeparator}widget.evc")
      //         .writeAsBytesSync(utf8.encode(content["implementation"]));
      //     File("$path${Platform.pathSeparator}state").create();
      //     setState(() {
      //       groups.add(_subscribe(Directory(path), users));
      //     });
      //   }
    }
  }

  @override
  void dispose() {
    if (connection != null) {
      connection!.close();
    }
    super.dispose();
    File("${widget.groupDir}${Platform.pathSeparator}users.json")
        .writeAsString(jsonEncode(users));
    File("${widget.groupDir}${Platform.pathSeparator}details.json")
        .writeAsString(jsonEncode(details));
    File("${widget.groupDir}${Platform.pathSeparator}lastSid")
        .writeAsString(lastSid.toString());
  }
}
