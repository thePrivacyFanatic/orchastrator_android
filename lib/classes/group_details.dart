

class GroupDetails {
  final String gid;
  String displayName;
  final String relayURL;
  final String username;
  final String password;
  final String aesKey;

  GroupDetails(
      {required this.gid,
      required this.displayName,
      required this.relayURL,
      required this.username,
      required this.password,
      required this.aesKey,});

  GroupDetails.fromJson(Map<String, dynamic> json)
      : gid = json['gid'] as String,
        displayName = json['displayName'] as String,
        relayURL = json['relayURL'] as String,
        username = json['username'] as String,
        password = json['password'] as String,
        aesKey = json['AESKey'] as String;

  Map<String, dynamic> toJson() => {
        'gid': gid,
        'displayName': displayName,
        "relayURL": relayURL,
        "username": username,
        "password": password,
        "AESKey": aesKey
      };
}

class GroupDetailsConstructor {
  String? gid;
  String? displayName;
  String? relayURL;
  String? username;
  String? password;
  String? aesKey;

  GroupDetails construct() => GroupDetails(
      gid: gid!,
      displayName: displayName!,
      relayURL: "ws://${relayURL!}",
      username: username!,
      password: password!,
      aesKey: aesKey!);


  GroupDetailsConstructor.empty();

  GroupDetailsConstructor.edit(GroupDetails oldDetails) :
        gid = oldDetails.gid,
        displayName = oldDetails.displayName,
        relayURL = oldDetails.relayURL,
        username = oldDetails.username,
        password = oldDetails.password,
        aesKey = oldDetails.aesKey;
}