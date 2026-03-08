import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/connection_handler.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/objectives/eventlog.dart';
import 'package:orchastrator/pages/group_settings.dart';

import '../classes/bindings.dart';
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
  // non modular but will require a more thorough replacement
  final List<User> users = List<User>.empty(growable: true);
  final List<Widget> containers = List<Widget>.empty(growable: true);
  ValueNotifier<User> me = ValueNotifier(
      User(uid: 999, name: "unknown", privilege: Privilege.listener));
  late int lastSid = int.parse(
      File("${widget.groupDir}${Platform.pathSeparator}lastSid")
          .readAsStringSync());

  @override
  void initState() {
    super.initState();
    for (var str in (jsonDecode(
        File("${widget.groupDir}${Platform.pathSeparator}users.json")
            .readAsStringSync()) as List)) {
      var user = User.fromJson(str);
      users.add(user);
      if (user.name == details.username) {
        me.value = user;
      }
    }
    containers.add(EventList(input: _subscribe(0, users)));
    containers.add(Chat(input: _subscribe(1, users)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ConnectionHandler.fromGroup(details, lastSid),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: const Text("Connecting..."),),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("connecting to the server..."),
                    CircularProgressIndicator()
                  ],
                ),
              ),
            );
          }
          if (asyncSnapshot.hasError)
          {
            return Scaffold(
              appBar: AppBar(title: const Text("now this is awkward..."),),
              body: Center(child: ErrorScreenBody(error: asyncSnapshot.error!)),
            );
          }
          connection = asyncSnapshot.data;
          connection!.received.listen(_receive);
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
                              me: me,
                              connection: connection!,
                              users: users,
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
              body: ListView.builder(
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 300,
                    child: Card(child: containers[index]),
                  );
                },
                itemCount: containers.length,
              ));
        });
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
        me: me,
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
          me.value = user;
        }
      case ("perm"):
        users.firstWhere((user) {
          return user.uid == content["uid"];
        }).privilege = Privilege.values[content["new"] as int];
        broadcast(message);
        if (content["uid"] == me.value.uid) {
          var newMe = me.value;
          newMe.privilege = Privilege.values[content["new"] as int];
          me.value = newMe;
        }
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
    File("${widget.groupDir}${Platform.pathSeparator}lastSid")
        .writeAsString(lastSid.toString());
  }
}

class ErrorScreenBody extends StatelessWidget {
  final Object error;
  const ErrorScreenBody({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    if (error is IOException) {
      return Column(
        children: [
          const Text(
            "we could not connect to the server :(",
          ),
          const Text("here is the error message:"),
          Text(error.toString())
        ],
      );
    }
    if (error is LoginFail) {
      return const Text("could not log into your account :(");
    }
    if (error is FlutterError) {
      return ErrorWidget.withDetails(
        error: error as FlutterError,
      );
    }
    return ErrorWidget(error);
  }
}

