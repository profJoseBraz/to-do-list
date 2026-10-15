// import traz código de outro arquivo para este arquivo poder usar.
// material.dart é a biblioteca visual do Flutter (botões, textos, temas).
import 'package:flutter/material.dart';

// Importa a tela principal da lista de tarefas.
import 'pages/home_page.dart';
// Importa a tela de login, primeira tela se o aluno ainda não entrou.
import 'pages/login_page.dart';
// Importa o serviço que lê login e configurações no celular/Windows.
import 'services/app_storage.dart';

// main() é o ponto de entrada. O Flutter começa a executar daqui.
void main() {
  // runApp coloca o widget TodoApp na tela e inicia o aplicativo.
  runApp(const TodoApp());
}

// TodoApp é o widget raiz. É StatefulWidget porque o tema e o login
// mudam enquanto o aplicativo está aberto.
class TodoApp extends StatefulWidget {
  // const ajuda o Flutter a reutilizar este widget quando nada mudou.
  // super.key identifica este widget na árvore de telas.
  const TodoApp({super.key});

  // createState cria o objeto que guarda os dados (login, tema, loading).
  @override
  State<TodoApp> createState() => _TodoAppState();
}

// _TodoAppState é a parte que realmente lembra os valores.
// O underline deixa a classe privada deste arquivo.
class _TodoAppState extends State<TodoApp> {
  // AppStorage conversa com o SharedPreferences (armazenamento local).
  final AppStorage _appStorage = AppStorage();

  // true enquanto estamos lendo os dados salvos. Mostra um loading.
  bool _isLoading = true;
  // true se o aluno já fez login e pode ver a Home.
  bool _isLoggedIn = false;
  // true se o aluno escolheu o modo escuro.
  bool _darkMode = false;

  // initState roda uma vez, quando o aplicativo nasce.
  @override
  void initState() {
    // super.initState() avisa a classe pai que começamos.
    super.initState();
    // Em seguida carregamos login e tema salvos no aparelho.
    _loadAppState();
  }

  // Future<void> = função demorada que não devolve um valor útil.
  // async permite usar await para esperar o armazenamento.
  Future<void> _loadAppState() async {
    // Garante que o usuário aluno / senha 1234 exista na primeira vez.
    await _appStorage.ensureDefaultUser();
    // Lê se o aluno já estava logado da última vez.
    final isLoggedIn = await _appStorage.loadIsLoggedIn();
    // Lê as preferências (tema escuro e confirmar exclusão).
    final settings = await _appStorage.loadSettings();

    // setState avisa o Flutter: os dados mudaram, desenhe a tela de novo.
    setState(() {
      // Copia o login lido para a variável da tela.
      _isLoggedIn = isLoggedIn;
      // Copia a escolha de tema.
      _darkMode = settings.darkMode;
      // Acabou o carregamento: podemos mostrar Login ou Home.
      _isLoading = false;
    });
  }

  // Chamada pela LoginPage quando usuário e senha estão corretos.
  void _handleLogin() {
    setState(() {
      // Agora o aluno está dentro do app.
      _isLoggedIn = true;
    });
  }

  // Chamada pela SettingsPage quando o aluno confirma "Sair".
  void _handleLogout() {
    setState(() {
      // Volta para a tela de login. As tarefas NÃO são apagadas.
      _isLoggedIn = false;
    });
  }

  // Chamada quando o interruptor de modo escuro muda.
  // bool darkMode chega true (escuro) ou false (claro).
  void _handleThemeChanged(bool darkMode) {
    setState(() {
      // Atualiza o tema de todo o aplicativo.
      _darkMode = darkMode;
    });
  }

  // build desenha o aplicativo inteiro: tema + tela inicial.
  @override
  Widget build(BuildContext context) {
    // Cor semente do Material 3. O Flutter gera as outras cores a partir dela.
    // 0xFF1565C0 é um azul (FF = opaco, 1565C0 = o tom).
    const seedColor = Color(0xFF1565C0);

    // MaterialApp configura título, temas e a primeira tela.
    return MaterialApp(
      // Nome que aparece na lista de apps / barra do Windows.
      title: 'Minhas tarefas',
      // Esconde a faixa "DEBUG" do canto da tela.
      debugShowCheckedModeBanner: false,
      // theme é o visual do modo claro.
      theme: ThemeData(
        // useMaterial3 liga o visual moderno do Material Design 3.
        useMaterial3: true,
        // ColorScheme.fromSeed cria um conjunto harmônico de cores.
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
        ),
        // AppBar com título alinhado à esquerda, não no centro.
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      // darkTheme é o visual do modo escuro.
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: seedColor,
          // Brightness.dark pede cores escuras a partir da mesma semente.
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
        ),
      ),
      // ThemeMode escolhe qual tema usar agora.
      // Se _darkMode for true, usa escuro; senão, usa claro.
      themeMode: _darkMode ? ThemeMode.dark : ThemeMode.light,
      // home é a primeira tela. Aqui usamos um if em cadeia:
      // ainda carregando? mostra loading.
      // já logado? mostra Home.
      // senão, mostra Login.
      home: _isLoading
          ? const Scaffold(
              // CircularProgressIndicator é a rodinha de "carregando".
              body: Center(child: CircularProgressIndicator()),
            )
          : _isLoggedIn
              ? HomePage(
                  // Entrega as funções para a Home poder sair e mudar o tema.
                  onLogout: _handleLogout,
                  onThemeChanged: _handleThemeChanged,
                )
              : LoginPage(onLogin: _handleLogin),
    );
  }
}
