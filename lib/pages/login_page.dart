// import traz código de outro arquivo para este arquivo poder usar.
// material.dart é a biblioteca visual do Flutter (botões, textos, telas).
import 'package:flutter/material.dart';

// Este import busca o AppStorage, a classe que lê e grava login no celular.
// '../' sobe um nível de pasta (sai de pages/ e vai para lib/).
import '../services/app_storage.dart';

// class cria um molde. LoginPage é o molde da tela de login.
// extends StatefulWidget significa: esta tela TEM estado
// (os textos digitados nos campos mudam enquanto o app está aberto).
class LoginPage extends StatefulWidget {
  // VoidCallback é um tipo: "uma função que não recebe nada e não devolve nada".
  // onLogin será chamada quando o aluno entrar com usuário e senha corretos.
  // final significa que esse valor não muda depois que o widget é criado.
  final VoidCallback onLogin;

  // const no construtor ajuda o Flutter a otimizar a tela
  // quando nada importante mudou.
  const LoginPage({
    // super.key entrega a chave ao widget pai. O Flutter usa isso
    // para identificar este widget na árvore de telas.
    super.key,
    // required obriga quem criar a LoginPage a passar a função onLogin.
    required this.onLogin,
  });

  // @override avisa que estamos substituindo um método que já existe na classe pai.
  // createState() cria o objeto que realmente guarda os dados da tela.
  // O underline em _LoginPageState significa: classe privada deste arquivo.
  @override
  State<LoginPage> createState() => _LoginPageState();
}

// _LoginPageState é a segunda parte do StatefulWidget.
// É aqui que ficam os controllers, a validação e o desenho da tela.
// State<LoginPage> liga este estado à LoginPage.
class _LoginPageState extends State<LoginPage> {
  // AppStorage é o objeto que conversa com o SharedPreferences.
  // Usamos ele para conferir usuário/senha e marcar que o aluno entrou.
  final AppStorage _appStorage = AppStorage();

  // TextEditingController lê o que o aluno digitou no campo.
  // Este controller está ligado ao campo "Usuário".
  final TextEditingController _usernameController = TextEditingController();

  // Este controller está ligado ao campo "Senha".
  final TextEditingController _passwordController = TextEditingController();

  // dispose() roda quando a tela de login sai da memória.
  // Precisamos liberar os controllers para não ocupar RAM à toa.
  @override
  void dispose() {
    // dispose() do controller corta a ligação com o campo de texto.
    _usernameController.dispose();
    // O mesmo para o campo de senha.
    _passwordController.dispose();
    // super.dispose() avisa a classe pai que terminamos a limpeza.
    super.dispose();
  }

  // Future<void> significa: esta função vai demorar um pouco
  // (ler o armazenamento) e não devolve um valor útil no final.
  // async permite usar await dentro dela.
  Future<void> _login() async {
    // .text pega o texto digitado. .trim() tira espaços do começo e do fim.
    // Assim " aluno " vira "aluno".
    final username = _usernameController.text.trim();
    // Faz a mesma leitura no campo de senha.
    final password = _passwordController.text.trim();

    // await espera o resultado chegar antes de continuar.
    // validateLogin compara o que foi digitado com o que está salvo no celular.
    // isValid fica true se estiver certo, ou false se estiver errado.
    final isValid = await _appStorage.validateLogin(username, password);

    // mounted pergunta: "esta tela ainda está na árvore de widgets?"
    // Depois de um await, o aluno pode ter saído da tela.
    // Se não estiver mais montada, paramos para não usar um context morto.
    if (!mounted) {
      // return encerra a função imediatamente.
      return;
    }

    // O ponto de exclamação em !isValid significa "se NÃO for válido".
    if (!isValid) {
      // ScaffoldMessenger mostra mensagens rápidas na parte de baixo da tela.
      // of(context) encontra o Scaffold desta tela.
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar é a faixa preta/colorida com um recado curto.
        const SnackBar(
          // content é o que aparece dentro da faixa.
          content: Text('Usuário ou senha incorretos.'),
        ),
      );
      // return impede que o código continue e entre no app com senha errada.
      return;
    }

    // Se chegou aqui, o login está correto.
    // setLoggedIn(true) grava no celular: "este aluno já entrou".
    // Na próxima abertura do app, ele pode ir direto para a Home.
    await _appStorage.setLoggedIn(true);
    // widget. acessa o que foi passado para a LoginPage.
    // onLogin() avisa o TodoApp para trocar esta tela pela HomePage.
    widget.onLogin();
  }

  // build() é o método que DESENHA a tela.
  // O Flutter chama build sempre que precisa mostrar ou atualizar a interface.
  // context é o "endereço" deste widget na árvore (serve para tema, snackbar, etc.).
  @override
  Widget build(BuildContext context) {
    // Theme.of(context) lê o tema global do MaterialApp.
    // colorScheme traz as cores (azul principal, fundo, texto...).
    final colorScheme = Theme.of(context).colorScheme;
    // textTheme traz os estilos de letra (título, corpo, etc.).
    final textTheme = Theme.of(context).textTheme;

    // return devolve o widget que será mostrado.
    // Scaffold é a estrutura básica de uma tela (fundo, app bar, corpo).
    return Scaffold(
      // body é o conteúdo principal da tela.
      body: SafeArea(
        // SafeArea empurra o conteúdo para não ficar atrás do notch
        // ou da barra de status do celular.
        child: Center(
          // Center coloca o filho no meio da tela, na horizontal e na vertical.
          child: SingleChildScrollView(
            // SingleChildScrollView permite rolar se o teclado cobrir os campos.
            // padding cria um espaço interno de 24 pixels em todos os lados.
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              // ConstrainedBox limita o tamanho do conteúdo.
              // maxWidth: 400 evita que os campos fiquem enormes no Windows.
              constraints: const BoxConstraints(maxWidth: 400),
              child: Column(
                // Column empilha os filhos de cima para baixo.
                children: [
                  // Icon desenha um desenho do Material Icons.
                  Icon(
                    // check_circle_outline é o ícone de "certo" com círculo.
                    Icons.check_circle_outline,
                    // size é o tamanho do ícone em pixels lógicos.
                    size: 72,
                    // color usa a cor principal do tema (o azul do app).
                    color: colorScheme.primary,
                  ),
                  // SizedBox só ocupa espaço. Aqui cria 16 pixels de altura vazia.
                  const SizedBox(height: 16),
                  // Text mostra uma frase na tela.
                  Text(
                    // Este é o título do aplicativo.
                    'Minhas Tarefas',
                    // style define aparência da letra.
                    // ?. só usa copyWith se headlineSmall não for nulo.
                    style: textTheme.headlineSmall?.copyWith(
                      // FontWeight.bold deixa o título em negrito.
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Espaço menor entre o título e o subtítulo.
                  const SizedBox(height: 8),
                  Text(
                    // Frase de apoio, igual à da Home.
                    'Organize seu dia',
                    style: textTheme.bodyLarge?.copyWith(
                      // onSurfaceVariant é uma cor um pouco mais fraca,
                      // para o subtítulo não competir com o título.
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  // Espaço maior antes do formulário.
                  const SizedBox(height: 40),
                  // TextField é a caixinha onde o aluno digita.
                  TextField(
                    // Liga este campo ao controller de usuário.
                    controller: _usernameController,
                    // textInputAction.next: no teclado, o botão vira "Próximo"
                    // e pula para o campo de senha.
                    textInputAction: TextInputAction.next,
                    // decoration cuida do visual da caixinha (borda, rótulo, dica).
                    decoration: InputDecoration(
                      // labelText é o nome do campo, que sobe quando o aluno digita.
                      labelText: 'Usuário',
                      // hintText é o exemplo cinza dentro do campo vazio.
                      hintText: 'aluno',
                      // OutlineInputBorder desenha um retângulo com borda ao redor.
                      border: OutlineInputBorder(
                        // BorderRadius.circular(12) arredonda os cantos.
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // Espaço entre os dois campos.
                  const SizedBox(height: 16),
                  TextField(
                    // Liga este campo ao controller de senha.
                    controller: _passwordController,
                    // obscureText: true esconde a senha com bolinhas (••••).
                    obscureText: true,
                    // done indica "terminei de digitar".
                    textInputAction: TextInputAction.done,
                    // onSubmitted roda quando o aluno aperta Enter.
                    // (_) significa: recebemos o texto, mas não vamos usar.
                    // Em vez disso, chamamos a mesma função do botão ENTRAR.
                    onSubmitted: (_) => _login(),
                    decoration: InputDecoration(
                      labelText: 'Senha',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  // Espaço entre o campo de senha e o botão.
                  const SizedBox(height: 24),
                  // SizedBox força largura e altura do botão.
                  SizedBox(
                    // double.infinity = "ocupe a largura inteira do pai".
                    width: double.infinity,
                    // Altura fixa deixa o botão fácil de tocar.
                    height: 52,
                    child: FilledButton(
                      // onPressed é o que acontece ao tocar no botão.
                      // Passamos _login sem parênteses: estamos entregando a função,
                      // não executando ela agora.
                      onPressed: _login,
                      // child é o conteúdo visual do botão.
                      child: const Text('ENTRAR'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
