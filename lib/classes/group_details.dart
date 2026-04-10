/// class for the details about a group that are stored in a file
///
/// some like [displayName] will probably be moved when i get over to refactoring this
class GroupDetails {
  final bool secure;
  final String gid;
  String displayName;
  final String relayHost;
  final String username;
  final String password;
  final String aesKey;

  GroupDetails({
    required this.gid,
    required this.displayName,
    required this.relayHost,
    required this.username,
    required this.password,
    required this.aesKey, required this.secure,
  });

  /// deserialization constructor for the class
  GroupDetails.fromJson(Map<String, dynamic> json)
      : gid = json['gid'] as String,
        displayName = json['displayName'] as String,
        relayHost = json['relayHost'] as String,
        username = json['username'] as String,
        password = json['password'] as String,
        aesKey = json['AESKey'] as String,
        secure = json['secure'] as bool;

  /// serialization function for the class
  Map<String, dynamic> toJson() => {
        'gid': gid,
        'displayName': displayName,
        "relayHost": relayHost,
        "username": username,
        "password": password,
        "AESKey": aesKey,
        "secure": secure
      };
}
