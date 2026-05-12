import 'package:flutter/material.dart';
import 'package:antipattern/widgets/app_background.dart';
import 'package:antipattern/widgets/universal_action_bar.dart';
import 'package:antipattern/widgets/glass_container.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 100, 16, 40),
              child: GlassContainer(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: const Text("Enable Notifications"),
                      value: notifications,
                      onChanged: (v) =>
                          setState(() => notifications = v),
                    ),
                    SwitchListTile(
                      title: const Text("Dark Mode"),
                      value: darkMode,
                      onChanged: (v) =>
                          setState(() => darkMode = v),
                    ),
                  ],
                ),
              ),
            ),

            const TopOverlayActionBar(),
          ],
        ),
      ),
    );
  }
}