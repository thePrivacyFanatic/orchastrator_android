import 'dart:io';

import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:eval_annotation/eval_annotation.dart';

@Bind()
class Message {
  String content;
  final int timestamp;
  final int sender;
  final int mtype;

  Message(
      {required this.content, required this.timestamp, required this.sender, required this.mtype});

  Message.fromJson(Map<String, dynamic> jsonString)
      : content = jsonString["content"],
        timestamp = jsonString["timestamp"],
        sender = jsonString["sender"],
        mtype = jsonString["mtype"];

  @override
  String toString() {
    return "sender: $sender \n timestamp: $timestamp \n content: $content";
  }
}

@Bind()
class User {
  final int uid;
  final String username;
  int privilege;

  User({required this.uid, required this.username, required this.privilege});

  User.fromJson(Map<String, dynamic> jsonString)
      : uid = jsonString["uid"] as int,
        username = jsonString["username"] as String,
        privilege = jsonString["privilege"] as int;
}

@Bind()
class ObjectiveInput {
  final Stream<Message> receiver;
  final $Closure send;
  final List<User> users;
  final File state;

  ObjectiveInput({required this.receiver, required this.send, required this.users, required this.state});
}

