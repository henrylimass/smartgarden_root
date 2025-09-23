import 'package:shared_preferences/shared_preferences.dart';

enum ThemeOption { light, dark, system }

class PreferencesService {

  Future<void> saveTheme(ThemeOption theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_option', theme.index);
  }


  Future<ThemeOption> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt('theme_option') ?? ThemeOption.system.index;
    return ThemeOption.values[themeIndex];
  }


  Future<void> saveNotifications(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
  }


  Future<bool> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool('notifications_enabled') ?? true;
  }
}