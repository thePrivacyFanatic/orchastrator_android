import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aes256/aes256.dart';
import 'package:async/async.dart';
import 'package:orchastrator/classes/bindings.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/classes/login.dart';

class LoginFail extends Error {}

class ConnectionHandler {
  final WebSocket _connection;
  final String _passphrase;
  late final StreamSplitter<dynamic> _splitter = StreamSplitter(_connection);
  late final Stream<Message> received = _splitter.split().skip(1).asyncMap(_decrypt);

  ConnectionHandler._(String secretKey, {required WebSocket connection})
      : _connection = connection,
        _passphrase = secretKey;

  static Future<ConnectionHandler> fromGroup(
      GroupDetails details, int lastSid) async {
    var connection =
    await WebSocket.connect("ws://${details.relayURL}/${details.gid}");
    var handler =  ConnectionHandler._(details.aesKey, connection: connection);
    await handler._hello(details.username, details.password, lastSid);
    return handler;
  }

  Future<void> _hello(String username, String password, int lastSid) async {
    _connection.add(jsonEncode(Login(username: username, password: password)));
    try {
      await _splitter.split().first;
    } on StateError catch (_) {
      throw LoginFail();
    }
    _connection.add(lastSid.toString());
  }

  Future<Message> _decrypt(dynamic received) async {
    var message = Message.fromJson(jsonDecode(received.toString()));
    if (message.mtype == 0) {
      message.content = await Aes256.decrypt(
          encrypted: message.content, passphrase: _passphrase);
    }
    return message;
  }

  Future<void> send(String message) async {
    var encrypted =
        await Aes256.encrypt(text: message, passphrase: _passphrase);
    _connection.add(jsonEncode({"content": encrypted, "mtype": 0}));
  }

  void sendExt(String message) {
    _connection.add(jsonEncode({"content": message, "mtype": 1}));
  }

  void close() {
    _connection.close(WebSocketStatus.normalClosure);
  }
}
