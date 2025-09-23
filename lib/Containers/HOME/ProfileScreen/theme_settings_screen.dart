// lib/theme_settings_screen.dart
import 'package:flutter/material.dart';
import '/services/app_enums.dart';
class ThemeSettingsScreen extends StatefulWidget {
  final ThemeOption currentTheme;
  const ThemeSettingsScreen({super.key, required this.currentTheme});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late ThemeOption _selectedTheme;

  @override
  void initState() {
    super.initState();
    _selectedTheme = widget.currentTheme;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tema"),
        backgroundColor: const Color(0xFF0E520E),
      ),
      body: Column(
        children: [
          RadioListTile<ThemeOption>(
            title: const Text("Claro"),
            value: ThemeOption.light,
            groupValue: _selectedTheme,
            onChanged: (value) => _updateTheme(value!),
          ),
          RadioListTile<ThemeOption>(
            title: const Text("Escuro"),
            value: ThemeOption.dark,
            groupValue: _selectedTheme,
            onChanged: (value) => _updateTheme(value!),
          ),
          RadioListTile<ThemeOption>(
            title: const Text("Automático (Padrão do Sistema)"),
            value: ThemeOption.system,
            groupValue: _selectedTheme,
            onChanged: (value) => _updateTheme(value!),
          ),
        ],
      ),
    );
  }
  void _updateTheme(ThemeOption value) {
    setState(() {
      _selectedTheme = value;
    });
    Navigator.of(context).pop(_selectedTheme);
  }
}