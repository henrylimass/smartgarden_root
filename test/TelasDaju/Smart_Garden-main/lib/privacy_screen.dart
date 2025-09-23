// lib/privacy_screen.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Privacidade e Segurança"),
        backgroundColor: const Color(0xFF0E520E),
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: Icon(BootstrapIcons.file_text),
            title: Text("Política de Privacidade"),
            trailing: Icon(Icons.chevron_right),
          ),
          ListTile(
            leading: Icon(BootstrapIcons.file_earmark_ruled),
            title: Text("Termos de Serviço"),
            trailing: Icon(Icons.chevron_right),
          ),
           ListTile(
            leading: Icon(BootstrapIcons.share),
            title: Text("Gerenciamento de Dados"),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}