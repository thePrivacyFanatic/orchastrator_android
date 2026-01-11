import 'package:flutter/material.dart';
import 'package:orchastrator/pages/app_settings.dart';
import 'package:orchastrator/pages/instance_page.dart';
import 'package:orchastrator/components/add_instance_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Instances'),
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
      body: SafeArea(
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (context, index) => SizedBox(
            child: ListTile(
              leading: SizedBox(
                child: Row(
                  spacing: 50,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                      Text(
                        'Instance',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Text(
                        'Username',
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InstancePage(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddInstanceDialog(),
            anchorPoint: const Offset(0, 0),
          );
        },
        tooltip: 'Add new instance...',
        child: const Icon(Icons.add),
      ),
    );
  }
}
