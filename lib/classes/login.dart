import 'package:orchastrator/classes/group_details.dart';

/// dataclass for creadetials sent to the server
class Login {
  final String username;
  final String password;

  Login({required this.username, required this.password});

  Login.fromDetails(GroupDetails group)
      : this(username: group.username, password: group.password);

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
      };
}
