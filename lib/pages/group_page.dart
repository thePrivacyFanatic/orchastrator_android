import 'package:flutter/material.dart';
import 'package:orchastrator/pages/group_settings.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group name'),
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
              tooltip: 'app settings',
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 5, horizontal: 10),
          child: Card.filled(
            color: Theme.of(context).highlightColor,
            child: SizedBox(
                height: 500, child: Center(child: Text('automation $index'))),
          ),
        ),
        itemCount: 5,
      ),
    );
  }
}
