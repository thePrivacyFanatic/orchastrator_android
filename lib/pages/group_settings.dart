import 'package:flutter/material.dart';

class GroupSettings extends StatelessWidget {
  const GroupSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Notifications',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: 300,
            child: ListTile(
              leading: Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: const Text('Enable'),
              subtitle: const Text('Always'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 361,
            height: 8,
            child: Card( child: Text(
                'General',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.language,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Lorem'),
                  subtitle: const Text('Impsum'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Dolor'),
                  subtitle: const Text('Sit amet'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
