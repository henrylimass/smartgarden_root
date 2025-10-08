// lib/language_settings_screen.dart
import 'package:flutter/material.dart';

class LanguageSettingsScreen extends StatefulWidget {
  final String currentLanguage;
  const LanguageSettingsScreen({super.key, required this.currentLanguage});

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  late String _selectedLanguage;
  final List<String> _languages = ["Português", "English", "Español"];

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Idioma"),
        backgroundColor: const Color(0xFF0E520E),
      ),
      body: ListView.builder(
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final language = _languages[index];
          return RadioListTile<String>(
            title: Text(language),
            value: language,
            groupValue: _selectedLanguage,
            onChanged: (value) {
              setState(() {
                _selectedLanguage = value!;
              });
              // Retorna o idioma selecionado para a tela anterior
              Navigator.of(context).pop(_selectedLanguage);
            },
          );
        },
      ),
    );
  }
}