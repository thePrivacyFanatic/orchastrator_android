import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:orchastrator/bindings.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/classes/login.dart';

class ConnectionHandler {
  final WebSocket _connection;
  final AesCrypt _crypt;
  late final Stream<Message> received = _connection.map(_decrypt);

  ConnectionHandler._(String secretKey, {required WebSocket connection})
      : _connection = connection,
        _crypt = AesCrypt(secretKey);

  static Future<ConnectionHandler> fromGroup(
      GroupDetails details, int lastSid) async {
    WebSocket connection;
    connection = await WebSocket.connect("ws://${details.relayURL}/${details.gid}");
    connection.add(jsonEncode(Login.fromDetails(details, lastSid)));
    if (connection.closeCode == 1008) {
      throw Exception("login fail");
    }return ConnectionHandler._(details.aesKey, connection: connection);
  }

  Message _decrypt(dynamic received) {
    var message = Message.fromJson(jsonDecode(received as String));
    if (message.mtype == 0) {
      message.content =
          utf8.decode(_crypt.aesEncrypt(utf8.encode(message.content)));
    }
    return message;
  }

  void send(String message) {
    var encrypted = utf8.decode(_crypt.aesEncrypt(utf8.encode(message)));
    _connection.add(jsonEncode({"content": encrypted, "mtype": 0}));
  }

  void sendExt(String message) {
    _connection.add(jsonEncode({"content": message, "mtype": 1}));
  }

  void close() {
    _connection.close(WebSocketStatus.normalClosure);
  }
}
