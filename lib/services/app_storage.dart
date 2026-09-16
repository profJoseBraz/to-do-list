import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_settings.dart';

// AppStorage guarda login e configurações no celular.
// As tarefas continuam no TaskStorage, para não misturar responsabilidades.
class AppStorage {
  static const String _loggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _darkModeKey = 'darkMode';
  static const String _confirmDeleteKey = 'confirmDelete';

  static const String defaultUsername = 'aluno';
  static const String defaultPassword = '1234';

  // Garante que o usuário didático exista na primeira execução.
  Future<void> ensureDefaultUser() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey(_usernameKey)) {
      await prefs.setString(_usernameKey, defaultUsername);
    }

    if (!prefs.containsKey(_passwordKey)) {
      await prefs.setString(_passwordKey, defaultPassword);
    }
  }

  Future<bool> loadIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_loggedInKey) ?? false;
  }

  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  // Neste projeto didático a senha é armazenada localmente
  // para simplificar o exemplo.
  // Em uma aplicação real, nunca devemos implementar
  // autenticação dessa forma.
  Future<bool> validateLogin(String username, String password) async {
    await ensureDefaultUser();
    final prefs = await SharedPreferences.getInstance();

    final savedUsername =
        prefs.getString(_usernameKey) ?? defaultUsername;
    final savedPassword =
        prefs.getString(_passwordKey) ?? defaultPassword;

    return username == savedUsername && password == savedPassword;
  }

  Future<String> loadPassword() async {
    await ensureDefaultUser();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey) ?? defaultPassword;
  }

  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, password);
  }

  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      darkMode: prefs.getBool(_darkModeKey) ?? false,
      confirmDelete: prefs.getBool(_confirmDeleteKey) ?? true,
    );
  }

  Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  Future<void> saveConfirmDelete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_confirmDeleteKey, value);
  }
}
