// lib/notification_settings_screen.dart
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _promotions = true;
  bool _appUpdates = true;
  bool _securityAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notificações"),
        backgroundColor: const Color(0xFF0E520E),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text("Promoções e Novidades"),
            subtitle: const Text("Receber ofertas especiais e notícias."),
            value: _promotions,
            onChanged: (value) => setState(() => _promotions = value),
          ),
          SwitchListTile(
            title: const Text("Atualizações do App"),
            subtitle: const Text("Saber quando novas funcionalidades estão disponíveis."),
            value: _appUpdates,
            onChanged: (value) => setState(() => _appUpdates = value),
          ),
          SwitchListTile(
            title: const Text("Alertas de Segurança"),
            subtitle: const Text("Receber avisos importantes sobre sua conta."),
            value: _securityAlerts,
            onChanged: (value) => setState(() => _securityAlerts = value),
          ),
        ],
      ),
    );
  }
}