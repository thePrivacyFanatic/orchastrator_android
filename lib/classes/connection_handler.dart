import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:orchastrator/bindings.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/classes/login.dart';

class ConnectionHandler {
  final WebSocket _connection;
  late final AesCrypt _crypt;
  final StreamController<Message> _internalsController = StreamController();
  late final Stream<Message> internals = _internalsController.stream;

  ConnectionHandler._(String secretKey, {required WebSocket connection})
      : _connection = connection {
    _crypt = AesCrypt(secretKey);
    _connection.listen(sortMessages);
  }

  static Future<ConnectionHandler> fromGroup(GroupDetails details) async {
    WebSocket connection;
    connection = await WebSocket.connect(details.relayURL);
    connection.add(Login.fromDetails(details).toJson());
    return ConnectionHandler._(details.aesKey, connection: connection);
  }

  Future<void> sortMessages(dynamic received) async {
    var message = Message.fromJson(jsonDecode(received as String));
    if (message.mtype == 1) {
      _internalsController.add(message);
    } else if (message.mtype == 0) {
      message.content =
          utf8.decode(_crypt.aesEncrypt(utf8.encode(message.content)));
      _internalsController.add(message);
    }
  }
  void send(String message) {
    var encrypted = utf8.decode(_crypt.aesEncrypt(utf8.encode(message)));
    _connection.add(jsonEncode({"content": encrypted, "mtype": 0}));
  }
  void sendExt(String message) {
    _connection.add(jsonEncode({"content": message, "mtype": 1}));
  }
}
