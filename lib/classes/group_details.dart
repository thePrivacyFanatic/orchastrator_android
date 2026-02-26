

class GroupDetails {
  final int gid;
  String displayName;
  final String relayURL;
  final String username;
  final String password;
  final String aesKey;
  int lastSid;

  GroupDetails(
      {required this.gid,
      required this.displayName,
      required this.relayURL,
      required this.username,
      required this.password,
      required this.aesKey,
      required this.lastSid});

  GroupDetails.fromJson(Map<String, dynamic> jsonString)
      : gid = jsonString['gid'] as int,
        displayName = jsonString['displayName'] as String,
        relayURL = jsonString['relayURL'] as String,
        username = jsonString['username'] as String,
        password = jsonString['password'] as String,
        aesKey = jsonString['AESKey'] as String,
        lastSid = jsonString['lastSid'] as int;

  Map<String, dynamic> toJson() => {
        'gid': gid,
        'displayName': displayName,
        "relayURL": relayURL,
        "username": username,
        "password": password,
        "AESKey": aesKey,
        "lastSid": lastSid
      };
}

class GroupDetailsConstructor {
  int? gid;
  String? displayName;
  String? relayURL;
  String? username;
  String? password;
  String? aesKey;

  GroupDetails construct() => GroupDetails(
      gid: gid!,
      displayName: displayName!,
      relayURL: Uri(scheme: "wss", host: Uri.parse(relayURL!).host).toString(),
      username: username!,
      password: password!,
      aesKey: aesKey!,
      lastSid: 0);


  GroupDetailsConstructor.empty();

  GroupDetailsConstructor.edit(GroupDetails oldDetails) :
        gid = oldDetails.gid,
        displayName = oldDetails.displayName,
        relayURL = oldDetails.relayURL,
        username = oldDetails.username,
        password = oldDetails.password,
        aesKey = oldDetails.aesKey;
}