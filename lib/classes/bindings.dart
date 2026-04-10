/// file for classes used inside objectives
///
/// bindings for classes in this file will be generated when the project switches over to dynamic code loading
library;
import 'dart:io';
import 'dart:core';
import 'package:flutter/material.dart';

/// enum for extensibility in comparisons
enum Privilege {
  banned,
  listener,
  publisher,
  moderator,
  admin;

  bool operator >(Privilege other) {
    return index > other.index;
  }

  bool operator <(Privilege other) {
    return index < other.index;
  }

  bool operator >=(Privilege other) {
    return index >= other.index;
  }

  bool operator <=(Privilege other) {
    return index <= other.index;
  }

  /// list of dropdown menu entries for permission dropdowns
  static final List<DropdownMenuEntry<Privilege>> menuEntries = Privilege.values
      .map((Privilege v) => DropdownMenuEntry(value: v, label: v.name))
      .toList();

  int toJson() => index;
}

/// dataclass for messages with serialization and deserialization
class Message {
  String content;
  final DateTime timestamp;
  final int sender;
  final int mtype;

  Message(
      {required this.content,
      required this.timestamp,
      required this.sender,
      required this.mtype});

  /// deserialization constructor for the class
  Message.fromJson(Map<String, dynamic> json)
      : content = json["content"],
        timestamp = DateTime.parse(json["timestamp"]),
        sender = json["sender"] as int,
        mtype = json["mtype"] as int;

  /// serialization function for the class
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

/// dataclass for user data
class User {
  final int uid;
  final String name;
  Privilege privilege;

  User({required this.uid, required this.name, required this.privilege});

  User.fromJson(Map<String, dynamic> json)
      : uid = json["uid"] as int,
        name = json["name"] as String,
        privilege = Privilege.values[json["privilege"] as int];

  Map<String, dynamic> toJson() =>
      {"uid": uid, "name": name, "privilege": privilege};
}

/// dataclass for the data each objective receives
///
/// this is used only since it enhances extensibility as it implements no functionality
class ObjectiveInput {
  final ValueNotifier<User> me;
  final Stream<Message> receiver;
  final Function send;
  final List<User> users;
  final File state;

  const ObjectiveInput(
      {required this.receiver,
      required this.send,
      required this.users,
      required this.state,
      required this.me});
}

/// premade object that owns all system messages
final systemUser = User(uid: 0, name: 'SYSTEM', privilege: Privilege.admin);
