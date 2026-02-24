

class GroupDetails {
  final int gid;
  final String displayName;
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
