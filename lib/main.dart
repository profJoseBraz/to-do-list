import 'package:flutter/material.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'services/app_storage.dart';

// main() é o ponto de entrada do aplicativo Flutter.
void main() {
  runApp(const TodoApp());
}

// TodoApp agora é StatefulWidget porque o tema e o login
// precisam mudar enquanto o aplicativo está aberto.
class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final AppStorage _appStorage = AppStorage();

  bool _isLoading = true;
  bool _isLoggedIn = false;
  bool _darkMode = false;

  @override
  void initState() {
    super.initState();
    _loadAppState();
  }

  Future<void> _loadAppState() async {
    await _appStorage.ensureDefaultUser();
    final isLoggedIn = await _appStorage.loadIsLoggedIn();
    final settings = await _appStorage.loadSettings();

    setState(() {
      _isLoggedIn = isLoggedIn;
      _darkMode = settings.darkMode;
      _isLoading = false;
    });
  }

  void _handleLogin() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  void _handleThemeChanged(bool darkMode) {
    setState(() {
      _darkMode = darkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF1565C0);

    return MaterialApp(
      title: 'Minhas tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      // ThemeMode escolhe o tema claro ou escuro em todo o aplicativo.
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      home: _isLoading
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : _isLoggedIn
              ? HomePage(
                  onLogout: _handleLogout,
                  onThemeChanged: _handleThemeChanged,
                )
              : LoginPage(onLogin: _handleLogin),
    );
  }
}
