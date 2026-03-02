import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orchastrator/bindings.dart';

class Chat extends StatefulWidget {
  final ObjectiveInput input;
  const Chat({super.key, required this.input});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<ChatMessage> messages = [];
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    var statefile = widget.input.state.readAsStringSync();
    for (var m in jsonDecode((statefile.isNotEmpty) ? statefile : "[]")) {
      messages.add(ChatMessage(message: Message.fromJson(m)));
    }
    widget.input.receiver
        .listen((message) => setState(() => messages.add(ChatMessage(message: message))));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => messages[index],
              itemCount: messages.length,
            )),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              IconButton(
                  onPressed: () {
                    widget.input.send(controller.text);
                  },
                  icon: Icon(Icons.send)),
              Expanded(
                child: TextField(
                  controller: controller,
                ),
              )
            ],
          ),
        )
      ],
    );
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
  const ChatMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text("${message.sender}"),
        title: Text(message.content),
        subtitle: Text("${message.timestamp}"),
      ),
    );
  }
}
