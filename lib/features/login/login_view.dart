import 'package:flutter/material.dart';
import 'login_controller.dart';

/// Displays the various settings that can be customized by the user.
///
/// When a user changes a setting, the LoginController is updated and
/// Widgets that listen to the LoginController are rebuilt.
class SettingsView extends StatelessWidget {
  const SettingsView({super.key, required this.controller});

  static const routeName = '/settings';

  final LoginController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Glue the LoginController to the theme selection DropdownButton.
        //
        // When a user selects a theme from the dropdown list, the
        // LoginController is updated, which rebuilds the MaterialApp.
        child: DropdownButton<ThemeMode>(
          // Read the selected themeMode from the controller
          value: controller.themeMode,
          // Call the updateThemeMode method any time the user selects a theme.
          onChanged: controller.updateThemeMode,
          items: const [
            DropdownMenuItem(
              value: ThemeMode.system,
              child: Text('System Theme'),
            ),
            DropdownMenuItem(
              value: ThemeMode.light,
              child: Text('Light Theme'),
            ),
            DropdownMenuItem(
              value: ThemeMode.dark,
              child: Text('Dark Theme'),
            )
          ],
        ),
      ),
    );
  }
}
