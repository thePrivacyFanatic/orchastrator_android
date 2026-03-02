import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aes256/aes256.dart';
import 'package:orchastrator/bindings.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/classes/login.dart';

class ConnectionHandler {
  final WebSocket _connection;
  final String _passphrase;
  late final Stream<Message> received = _connection.asyncMap(_decrypt);

  ConnectionHandler._(String secretKey, {required WebSocket connection})
      : _connection = connection,
        _passphrase = secretKey;

  static Future<ConnectionHandler> fromGroup(
      GroupDetails details, int lastSid) async {
    WebSocket connection;
    connection = await WebSocket.connect("ws://${details.relayURL}/${details.gid}");
    connection.add(jsonEncode(Login.fromDetails(details)));
    if (connection.closeCode == 1008) {
      throw Exception("login fail");
    }
    connection.add(lastSid.toString());
    return ConnectionHandler._(details.aesKey, connection: connection);
  }

  Future<Message> _decrypt(dynamic received) async {
    var message = Message.fromJson(jsonDecode(received as String));
    if (message.mtype == 0) {
      message.content =
          await Aes256.decrypt(encrypted: message.content, passphrase: _passphrase);
    }
    return message;
  }

  Future<void> send(String message) async {
    var encrypted = await Aes256.encrypt(text: message, passphrase: _passphrase);
    _connection.add(jsonEncode({"content": encrypted, "mtype": 0}));
  }

  void sendExt(String message) {
    _connection.add(jsonEncode({"content": message, "mtype": 1}));
  }

  void close() {
    _connection.close(WebSocketStatus.normalClosure);
  }
}
