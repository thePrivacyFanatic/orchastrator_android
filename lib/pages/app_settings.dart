import 'package:flutter/material.dart';
import 'package:orchastrator/globals/app_state.dart';

/// settings page for app
///
/// accessed from the homepage and is only concerned with global settings
class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    final currentThemeMode = appState.themeMode;
    final usePureBlack = appState.usePureBlack;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings'), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Appearance',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.brightness_auto,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('System Default'),
                  subtitle: const Text('Follow system theme'),
                  trailing: currentThemeMode == 'system'
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    appState.setThemeMode('system');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.light_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Light'),
                  subtitle: const Text('Light theme'),
                  trailing: currentThemeMode == 'light'
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    appState.setThemeMode('light');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.dark_mode,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Dark'),
                  subtitle: const Text('Dark theme'),
                  trailing: currentThemeMode == 'dark'
                      ? Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    appState.setThemeMode('dark');
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.contrast,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('Pure Black'),
                  subtitle: const Text('AMOLED pure black backgrounds'),
                  trailing: Switch(
                    value: usePureBlack,
                    onChanged: (value) {
                      appState.setPureBlack(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'General',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.info,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: const Text('About'),
                  subtitle: const Text('App version 1.0.0'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => showAboutDialog(context: context,
                  applicationName: "orchestrator",
                  applicationVersion: "1.1"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
