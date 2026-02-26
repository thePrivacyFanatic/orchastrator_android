import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/connection_handler.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/objectives/eventlog.dart';
import 'package:orchastrator/pages/group_settings.dart';

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
  final List<User> users = List<User>.empty();
  final StreamController<Widget> groups = StreamController();
  List<Widget> containers = List<Widget>.empty(growable: true);
  late final int privilege;

  @override
  void initState() {
    super.initState();
    final def = ObjectiveInput(
        receiver: Stream.empty(), send: () {}, users: [], state: File(""));
    List objectives = [
      EventList(
        input: def,
      )
    ];
    for (int i = 0; i < objectives.length; i++) {
      groups.add(objectives[i].load(_subscribe(i, users)));
    }
    for (var str in (jsonDecode(
        File("${widget.groupDir}${Platform.pathSeparator}users.json")
            .readAsStringSync()) as List)) {
      var user = User.fromJson(str);
      users.add(user);
      if (user.username == widget.details.username) {
        privilege = user.privilege;
      }
    }
  }

  Future<void> _connect() async {
    connection = await ConnectionHandler.fromGroup(widget.details);
    connection.received.listen(_receive);
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
                  return Center(child: Text("we could not connect to the server :("),);
                }
                if (asyncSnapshot.error is FlutterError) {
                  return Center(child: ErrorWidget.withDetails(error: asyncSnapshot.error as FlutterError,),);
                }
            }
            if (asyncSnapshot.connectionState == ConnectionState.done) {
              return StreamBuilder(
                  stream: groups.stream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.done) {
                      return Text('done');
                    } else if (snapshot.hasError) {
                      return Text('Error!');
                    } else {
                      containers.add(snapshot.data!);
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
                  });
            }
            return Center(
              child: CircularProgressIndicator(),
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
    }
  }

  ObjectiveInput _subscribe(int oid, List<User> users) {
    StreamController<Message> receiver = StreamController();
    streams[oid] = receiver;
    StreamController<String> controller = StreamController();
    controller.stream.listen((message) {
      connection.send(jsonEncode({"oid": oid, "content": message}));
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
        users.add(User.fromJson(content["user"]));
        broadcast(message);
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
    super.dispose();
    File("${widget.groupDir}${Platform.pathSeparator}users.json")
        .writeAsStringSync(jsonEncode(users));
  }
}
