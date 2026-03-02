import 'dart:io';
import 'dart:core';
import 'package:eval_annotation/eval_annotation.dart';


class Message {
  String content;
  final DateTime timestamp;
  final int sender;
  final int mtype;

  Message(
      {required this.content, required this.timestamp, required this.sender, required this.mtype});

  Message.fromJson(Map<String, dynamic> json)
      : content = json["content"],
        timestamp = DateTime.parse(json["timestamp"]),
        sender = json["sender"] as int,
        mtype = json["mtype"]as int;

  Map<String, dynamic> toJson() => {
    "content": content,
    "timestamp": timestamp.toString(),
    "sender": sender,
    "mtype": mtype
  };

  @override
  String toString() {
    return "sender: $sender \n timestamp: $timestamp \n content: $content";
  }
}


class User {
  final int uid;
  final String name;
  int privilege;

  User({required this.uid, required this.name, required this.privilege});

  User.fromJson(Map<String, dynamic> json)
      : uid = json["uid"] as int,
        name = json["name"] as String,
        privilege = json["privilege"] as int;

  Map<String, dynamic> toJson() => {
    "uid": uid,
    "name": name,
    "privilege": privilege
  };

}

@Bind()
class ObjectiveInput {
  final Stream<Message> receiver;
  final Function send;
  final List<User> users;
  final File state;

  ObjectiveInput({required this.receiver, required this.send, required this.users, required this.state});
}

