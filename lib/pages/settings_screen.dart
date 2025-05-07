import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _temperatureUnit = 'Celsius';
  List<String> _availableUnits = ['Celsius', 'Fahrenheit', 'Kelvin'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          ListTile(
            title: const Text('Notifications'),
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                  // Implement your notification toggling logic here
                  print('Notifications ${value ? 'enabled' : 'disabled'}');
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('Temperature Unit'),
            trailing: DropdownButton<String>(
              value: _temperatureUnit,
              items:
                  _availableUnits.map((String unit) {
                    return DropdownMenuItem<String>(
                      value: unit,
                      child: Text(unit),
                    );
                  }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _temperatureUnit = newValue!;
                  // Implement your temperature unit change logic here
                  print('Temperature unit changed to $_temperatureUnit');
                });
              },
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('About'),
            onTap: () {
              // Navigate to an "About" screen or show a dialog
              showAboutDialog(
                context: context,
                applicationName: 'Weather App',
                applicationVersion: '1.0.0',
                applicationLegalese: '© 2025 My Weather App',
              );
            },
          ),
          // Add more settings options as needed
        ],
      ),
    );
  }
}
