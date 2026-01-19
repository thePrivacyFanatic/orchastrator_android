import 'package:flutter/material.dart';
import 'package:orchastrator/pages/app_settings.dart';
import 'package:orchastrator/components/add_group_dialog.dart';
import 'package:orchastrator/components/group_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: key,
      appBar: AppBar(
        title: const Text('Saved Groups'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AppSettings()),
              );
            },
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            iconSize: 28,
            tooltip: 'app settings',
          ),
        ],
      ),
      body:  GroupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddGroupDialog(),
            anchorPoint: const Offset(0, 0),
          );
        },
        tooltip: 'Add new group...',
        child: const Icon(Icons.add),
      ),
    );
  }
}
