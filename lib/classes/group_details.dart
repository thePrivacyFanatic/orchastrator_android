class GroupDetails {
  final String gid;
  String displayName;
  final String relayURL;
  final String username;
  final String password;
  final String aesKey;

  GroupDetails({
    required this.gid,
    required this.displayName,
    required this.relayURL,
    required this.username,
    required this.password,
    required this.aesKey,
  });

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
