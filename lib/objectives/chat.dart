import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:orchastrator/bindings.dart';
import 'package:orchastrator/objectives/objective.dart';

class Chat extends StatefulWidget implements Objective {
  final ObjectiveInput input;
  const Chat({super.key, required this.input});

  @override
  State<Chat> createState() => _ChatState();

  @override
  Objective load(ObjectiveInput input) => Chat(input: input);
}

class _ChatState extends State<Chat> {
  final List<ChatMessage> messages = [];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder(
            stream: widget.input.receiver,
            builder: (context, message) {
              messages.add(ChatMessage(message: message.data!));
              return ListView.builder(
                  itemBuilder: (context, index) => messages[index]);
            }),
        Row(children: [
          IconButton(onPressed: () {widget.input.send(controller.text);}, icon: Icon(Icons.send)),
          TextField(controller: controller,)
        ],)
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.input.state.writeAsString(jsonEncode(messages.map((m) => m.message)));
  }

  @override
  void initState() {
    super.initState();
    var statefile = widget.input.state.readAsStringSync();
    for (var m in jsonDecode((statefile.isNotEmpty) ? statefile: "[]")) {
      messages.add(ChatMessage(message: Message.fromJson(m)));
    }
    }


}

class ChatMessage extends StatelessWidget {
  final Message message;
  const ChatMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(child: ListTile(leading: Text("${message.sender}"), title: Text(message.content), subtitle: Text("${message.timestamp}"),),);
  }
}
