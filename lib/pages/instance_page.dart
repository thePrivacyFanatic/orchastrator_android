import 'package:flutter/material.dart';
import 'package:orchastrator/pages/instance_settings.dart';

class InstancePage extends StatelessWidget {
  const InstancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instance name'),
        actions: [
          SizedBox(
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const InstanceSettings(),
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
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          alignment: const Alignment(0, 0),
          children: [
            ListView.builder(
              itemBuilder: (context, index) => Container(
                height: 200,
                decoration: const BoxDecoration(
                  color: Color(0x66ffe1b0),
                  border: Border(
                    bottom: BorderSide(color: Color(0xffc4c4c4), width: 1),
                  ),
                ),
                child: Center(child: Text('automation $index')),
              ),
              itemCount: 5,
            ),
          ],
        ),
      ),
    );
  }
}
