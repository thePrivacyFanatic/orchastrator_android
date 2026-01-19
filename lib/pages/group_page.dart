import 'package:flutter/material.dart';
import 'package:orchastrator/classes/group_details.dart';
import 'package:orchastrator/components/group_list.dart';
import 'package:orchastrator/pages/group_settings.dart';

class GroupPage extends StatelessWidget {
  final GroupDetails details;
  const GroupPage({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(details.displayName),
        actions: [
          SizedBox(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const GroupSettings(),
                  ),
                );
              },
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              iconSize: 28,
              tooltip: 'group settings',
            ),
          ),
        ],
      ),
      body: GroupList(),
    );
  }
}
