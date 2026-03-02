import 'package:orchastrator/classes/group_details.dart';

class Login {
  final String username;
  final String password;
  final int lastSid;

  Login(
      {
      required this.username,
      required this.password,
      required this.lastSid});

  Login.fromDetails(GroupDetails group, int lastSid)
      : this(
            username: group.username,
            password: group.password,
            lastSid: lastSid);

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "last_sid": lastSid
      };
}
