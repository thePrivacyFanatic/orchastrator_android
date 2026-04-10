import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orchastrator/classes/bindings.dart';

/// objective implementing text chat
class Chat extends StatefulWidget {
  final ObjectiveInput input;
  const Chat({super.key, required this.input});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<ChatMessage> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? lastSent;

  @override
  void initState() {
    super.initState();
    var stateFile = widget.input.state.readAsStringSync();
    messages.addAll(
        (jsonDecode((stateFile.isNotEmpty) ? stateFile : "[]") as List)
            .map((m) => ChatMessage(message: Message.fromJson(m), users: widget.input.users,)));
    widget.input.receiver.listen((message) {
      var msgWidget = ChatMessage(message: message, users: widget.input.users);
      setState(() => messages.add(msgWidget));
      if (_scrollController.position.extentAfter < 200) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: Duration(milliseconds: 80),
              curve: Curves.linear);
        });
      }
      if (message.content == lastSent) {
        setState(() {
          lastSent = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
          controller: _scrollController,
          itemBuilder: (context, index) => messages[index],
          itemCount: messages.length,
        )),
        if (widget.input.me.value.privilege >= Privilege.publisher)
          SizedBox(
            height: 50,
            child: Row(
              children: [
                (lastSent == null)
                    ? IconButton(
                        onPressed: send,
                        icon: const Icon(Icons.send))
                    : CircularProgressIndicator(),
                Expanded(
                  child: TextField(
                    onEditingComplete: send,
                    controller: _messageController,
                  ),
                ),
                IconButton(
                    onPressed: () => _scrollController
                        .jumpTo(_scrollController.position.maxScrollExtent),
                    icon: Icon(Icons.arrow_downward))
              ],
            ),
          )
      ],
    );
  }

  void send() {
    widget.input.send(_messageController.text);
    setState(() {
      lastSent = _messageController.text;
    });
    _messageController.clear();

  }

  @override
  void dispose() {
    super.dispose();
    widget.input.state
        .writeAsString(jsonEncode((messages.map((m) => m.message).toList())));
  }
}

class ChatMessage extends StatelessWidget {
  final Message message;
  final List<User> users;
  const ChatMessage({super.key, required this.message, required this.users});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (message.mtype == 0) ? Theme.of(context).cardColor: Theme.of(context).highlightColor,
      child: ListTile(
        leading: Text(users[message.sender].name),
        title: Text(message.content),
        subtitle: Text("${message.timestamp}"),
      ),
    );
  }
}
