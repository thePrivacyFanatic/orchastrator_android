import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aes256/aes256.dart';
import 'package:async/async.dart';
import 'package:orchastrator/classes/bindings.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/classes/login.dart';

class LoginFail extends Error {}

/// a class handling the websockets connection for the app
class ConnectionHandler {
  final WebSocket _connection;
  final String _passphrase;
  late final StreamSplitter<dynamic> _splitter = StreamSplitter(_connection);
  late final Stream<Message> received = _splitter.split().skip(1).asyncMap(_decrypt);

  ConnectionHandler._(String secretKey, {required WebSocket connection})
      : _connection = connection,
        _passphrase = secretKey;

  /// named constructor for the class that takes group details (credentials) and connects from them.
  static Future<ConnectionHandler> fromGroup(
      GroupDetails details, int lastSid) async {
    var connection =
    await WebSocket.connect("${details.secure ? "wss": "ws"}://${details.relayHost}/${details.gid}");
    var handler = ConnectionHandler._(details.aesKey, connection: connection);
    await handler._hello(details.username, details.password, lastSid);
    return handler;
  }

  /// function handling the login and erroring out if it fails for any reason
  Future<void> _hello(String username, String password, int lastSid) async {
    _connection.add(jsonEncode(Login(username: username, password: password)));
    try {
      await _splitter.split().first;
    } on StateError catch (_) {
      throw LoginFail();
    }
    _connection.add(lastSid.toString());
  }

  /// function that formats and decrypts internal messages for the objectives
  Future<Message> _decrypt(dynamic received) async {
    var message = Message.fromJson(jsonDecode(received.toString()));
    if (message.mtype == 0) {
      message.content = await Aes256.decrypt(
          encrypted: message.content, passphrase: _passphrase);
    }
    return message;
  }

  /// function sending an encrypted internal message
  Future<void> send(String message) async {
    var encrypted =
        await Aes256.encrypt(text: message, passphrase: _passphrase);
    _connection.add(jsonEncode({"content": encrypted, "mtype": 0}));
  }

  /// function sending external messages
  void sendExt(String message) {
    _connection.add(jsonEncode({"content": message, "mtype": 1}));
  }

  /// function closing the connection for when the app exits normally
  void close() {
    _connection.close(WebSocketStatus.normalClosure);
  }
}
