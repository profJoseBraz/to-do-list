// Pacote que grava pares chave/valor no aparelho, sem banco de dados.
import 'package:shared_preferences/shared_preferences.dart';

// AppSettings é o molde das preferências (tema e confirmar exclusão).
import '../models/app_settings.dart';

// AppStorage guarda login e configurações.
// As tarefas ficam no TaskStorage, para não misturar responsabilidades.
class AppStorage {
  // Nomes das "gavetas". static const = texto fixo da classe.
  static const String _loggedInKey = 'isLoggedIn';
  static const String _usernameKey = 'username';
  static const String _passwordKey = 'password';
  static const String _darkModeKey = 'darkMode';
  static const String _confirmDeleteKey = 'confirmDelete';

  // Credenciais iniciais do projeto didático.
  static const String defaultUsername = 'aluno';
  static const String defaultPassword = '1234';

  // Na primeira execução, cria o usuário aluno se ele ainda não existir.
  Future<void> ensureDefaultUser() async {
    // Pede acesso ao armazenamento local.
    final prefs = await SharedPreferences.getInstance();

    // containsKey pergunta: "já existe a gaveta username?"
    // O ! inverte: se NÃO existir, gravamos o padrão.
    if (!prefs.containsKey(_usernameKey)) {
      await prefs.setString(_usernameKey, defaultUsername);
    }

    // O mesmo para a senha inicial.
    if (!prefs.containsKey(_passwordKey)) {
      await prefs.setString(_passwordKey, defaultPassword);
    }
  }

  // Devolve true se o aluno já fez login e não saiu da conta.
  Future<bool> loadIsLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    // ?? false: se a gaveta estiver vazia, consideramos "não logado".
    return prefs.getBool(_loggedInKey) ?? false;
  }

  // Grava se o aluno está logado (true) ou saiu (false).
  Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_loggedInKey, value);
  }

  // Neste projeto didático a senha é armazenada localmente
  // para simplificar o exemplo.
  // Em uma aplicação real, nunca devemos implementar
  // autenticação dessa forma.
  Future<bool> validateLogin(String username, String password) async {
    // Garante que aluno/1234 existam antes de comparar.
    await ensureDefaultUser();
    final prefs = await SharedPreferences.getInstance();

    // Lê o usuário salvo. Se não houver, usa 'aluno'.
    final savedUsername =
        prefs.getString(_usernameKey) ?? defaultUsername;
    // Lê a senha salva. Se o aluno já alterou, vem a senha nova.
    final savedPassword =
        prefs.getString(_passwordKey) ?? defaultPassword;

    // && = os dois lados precisam ser iguais para o login ser válido.
    return username == savedUsername && password == savedPassword;
  }

  // Usado na tela de alterar senha, para conferir a senha atual.
  Future<String> loadPassword() async {
    await ensureDefaultUser();
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_passwordKey) ?? defaultPassword;
  }

  // Grava a nova senha depois da validação na SettingsPage.
  Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passwordKey, password);
  }

  // Monta um objeto AppSettings com o que está salvo no aparelho.
  Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return AppSettings(
      // Sem valor salvo, o tema começa claro.
      darkMode: prefs.getBool(_darkModeKey) ?? false,
      // Sem valor salvo, pedimos confirmação para excluir.
      confirmDelete: prefs.getBool(_confirmDeleteKey) ?? true,
    );
  }

  // Salva só a preferência de tema.
  Future<void> saveDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_darkModeKey, value);
  }

  // Salva só a preferência de confirmar exclusão.
  Future<void> saveConfirmDelete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_confirmDeleteKey, value);
  }
}
