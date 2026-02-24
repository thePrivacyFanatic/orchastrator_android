import 'package:orchastrator/classes/group_details.dart';

class Login {
  final int gid;
  final String username;
  final String password;
  final int lastSid;

  Login(
      {required this.gid,
      required this.username,
      required this.password,
      required this.lastSid});

  Login.fromDetails(GroupDetails group)
      : this(
            gid: group.gid,
            username: group.username,
            password: group.password,
            lastSid: group.lastSid);

  Map<String, dynamic> toJson() => {
        'gid': gid,
        "username": username,
        "password": password,
        "last_sid": lastSid
      };
}
