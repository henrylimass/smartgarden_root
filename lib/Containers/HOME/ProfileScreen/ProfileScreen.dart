// lib/ProfileScreen.dart
import 'package:flutter/material.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import '/services/app_enums.dart';

import '../ProfileScreen/edit_profile_screen.dart';
import '../ProfileScreen/theme_settings_screen.dart';
import '../ProfileScreen/language_settings_screen.dart';
import '../ProfileScreen/notification_settings_screen.dart';
import '../ProfileScreen/privacy_screen.dart';
import '../ProfileScreen/session_manager.dart';
import 'package:smartgarden_root/Containers/login/loginscreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ThemeOption _selectedTheme = ThemeOption.system;
  String _selectedLanguage = "Português";
  bool _notificationsEnabled = true;

  String _getThemeText(ThemeOption theme) {
    switch (theme) {
      case ThemeOption.light:
        return "Claro";
      case ThemeOption.dark:
        return "Escuro";
      case ThemeOption.system:
        return "Automático";
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Saída'),
          content: const Text('Você tem certeza que deseja sair?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Sair'),
              onPressed: () async {
                await SessionManager.setLoggedIn(false);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // suas cores originais
    const Color colorPrimary = Color(0xFF0E520E);
    const Color colorAccent = Color(0xFFFDB94F);
    const Color colorBackground = Color(0xFFF5F5F5);
    const Color colorCard = Colors.white;
    const Color colorTextTitle = Color(0xFF333333);
    const Color colorTextSubtitle = Color(0xFF808080);
    const Color colorTextSection = Colors.black54;
    const Color colorIconBackground = Color(0xFFF0F0F0);

    return Scaffold(
      backgroundColor: colorBackground,
      appBar: AppBar(
        backgroundColor: colorPrimary,
        elevation: 0,
        toolbarHeight: 80,
        automaticallyImplyLeading: false, // remove botão de voltar
        title: Text(
          "Menu do Usuário",
          style: GoogleFonts.montserratAlternates(
            color: colorAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(
            16,
            16,
            16,
            MediaQuery.of(context).padding.bottom + 24,
          ),
          children: [
            // Card de Perfil
            _buildOptionCard(
              onTap: () {},
              isProfile: true,
              titleWidget: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Maria Silva",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: colorTextTitle)),
                  SizedBox(height: 4),
                  Text("silvamaria@gmail.com",
                      style: TextStyle(color: colorTextSubtitle, fontSize: 14)),
                ],
              ),
              leadingWidget: const CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=5"),
              ),
            ),

            const SizedBox(height: 24),

            // Minha Conta
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text("Minha Conta",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorTextSection)),
            ),
            const SizedBox(height: 8),
            _buildOptionCard(
              icon: BootstrapIcons.person,
              title: "Meu perfil",
              subtitle: "Editar informações Pessoais",
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EditProfileScreen()))),
            const SizedBox(height: 24),

            // Preferências em um card
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text("Preferência do app",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: colorTextSection)),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 1.5,
              shadowColor: Colors.black.withOpacity(0.08),
              color: colorCard,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  _buildPreferenceItem(
                    icon: BootstrapIcons.translate,
                    title: "Idioma",
                    subtitle: _selectedLanguage,
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LanguageSettingsScreen(
                                  currentLanguage: _selectedLanguage)));
                      if (result != null && mounted)
                        setState(() => _selectedLanguage = result);
                    },
                  ),
                  const Divider(indent: 70, height: 1),
                  _buildPreferenceItem(
                    icon: BootstrapIcons.moon,
                    title: "Tema",
                    subtitle: _getThemeText(_selectedTheme),
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ThemeSettingsScreen(currentTheme: _selectedTheme)));
                      if (result != null && mounted)
                        setState(() => _selectedTheme = result);
                    },
                  ),
                  const Divider(indent: 70, height: 1),
                  _buildPreferenceItem(
                    icon: BootstrapIcons.bell,
                    title: "Notificações",
                    subtitle: "Gerenciar alertas",
                    trailing: Switch(
                      value: _notificationsEnabled,
                      onChanged: (value) =>
                          setState(() => _notificationsEnabled = value),
                      activeColor: colorPrimary,
                    ),
                  ),
                  const Divider(indent: 70, height: 1),
                  _buildPreferenceItem(
                    icon: BootstrapIcons.shield,
                    title: "Privacidade",
                    subtitle: "Controle e Segurança",
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PrivacyScreen())),
                  ),
                ],
              ),
            ),

            // Espaçamento e card Sair fora do card de preferências (visível no celular)
            const SizedBox(height: 24),
            _buildOptionCard(
              icon: BootstrapIcons.box_arrow_right,
              title: "Sair",
              isLogout: true,
              onTap: _showLogoutDialog,
            ),
          ],
        ),
      ),
    );
  }

  // Helper para os cards INDIVIDUAIS
  Widget _buildOptionCard({
    String? title,
    String? subtitle,
    IconData? icon,
    Widget? trailing,
    VoidCallback? onTap,
    bool isProfile = false,
    bool isLogout = false,
    Widget? leadingWidget,
    Widget? titleWidget,
  }) {
    const Color colorCard = Colors.white;
    const Color colorTextTitle = Color(0xFF333333);
    const Color colorTextSubtitle = Color(0xFF808080);
    const Color colorIconBackground = Color(0xFFF0F0F0);

    final Color itemColor = isLogout ? Colors.red : colorTextTitle;

    return Card(
      elevation: 1.5,
      shadowColor: Colors.black.withOpacity(0.08),
      color: colorCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: isProfile
            ? const EdgeInsets.fromLTRB(16, 8, 16, 8)
            : const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: leadingWidget ??
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: colorIconBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon!, size: 22, color: itemColor),
            ),
        title: titleWidget ??
            Text(title!,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: itemColor)),
        subtitle: isProfile
            ? null
            : (subtitle != null
                ? Text(subtitle,
                    style: const TextStyle(color: colorTextSubtitle))
                : null),
        trailing: trailing ??
            (onTap != null
                ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20)
                : null),
      ),
    );
  }

  // Helper para os itens dentro do card de preferências
  Widget _buildPreferenceItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    bool isLogout = false,
  }) {
    final Color itemColor = isLogout ? Colors.red : const Color(0xFF333333);

    Widget? computedTrailing = trailing ??
        (onTap != null ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20) : null);

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 22, color: itemColor),
      ),
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, color: itemColor)),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(color: Color(0xFF808080)))
          : null,
      trailing: computedTrailing,
    );
  }
}
