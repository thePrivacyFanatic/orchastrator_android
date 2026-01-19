class GroupDetails {
  final int gid;
  final String displayName;
  final Uri relayURL;
  final String username;
  final String password;
  final String aesKey;

  GroupDetails(
      {required this.gid,
      required this.displayName,
      required this.relayURL,
      required this.username,
      required this.password,
      required this.aesKey});

  GroupDetails.fromJson(Map<String, dynamic> jsonString)
      : gid = jsonString['gid'] as int,
        displayName = jsonString['displayName'] as String,
        relayURL = jsonString['url'] as Uri,
        username = jsonString['username'] as String,
        password = jsonString['password'] as String,
        aesKey = jsonString['AESKey'] as String;

  Map<String, dynamic> toJson() => {
        'gid': gid,
        'displayName': displayName,
        "relayURL": relayURL,
        "username": username,
        "password": password
      };
}
