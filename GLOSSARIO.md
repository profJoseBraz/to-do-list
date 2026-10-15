# Glossário — ToDo List Flutter

Termos do código deste aplicativo, para explicar em sala.

Para a primeira aula, três blocos costumam bastar: **`class` / objeto / `final`**, **`Widget` / `StatefulWidget` / `setState`**, **`Future` / `async` / `await`**. O resto entra quando o arquivo correspondente aparecer.

O roteiro de construção está em [ROTEIRO.md](ROTEIRO.md).

---

## 1. Palavras da linguagem Dart

| Termo | O que significa |
|---|---|
| **`import`** | Traz código de outro arquivo para este arquivo poder usar. |
| **`package:flutter/material.dart`** | Import da biblioteca visual do Flutter (botões, textos, telas). |
| **`../`** | Sobe uma pasta. De `pages/` para `lib/`, por exemplo. |
| **`class`** | Molde. Descreve quais dados um objeto pode ter. Ex.: `Task`, `HomePage`. |
| **objeto** | Uma “coisa” criada a partir da classe. Cada tarefa da lista é um objeto `Task`. |
| **`extends`** | Esta classe herda de outra. `HomePage extends StatefulWidget` = a Home é um tipo de widget com estado. |
| **construtor** | Função especial que cria o objeto. `Task(id: ..., title: ..., date: ...)`. |
| **`this`** | “Este objeto”. `this.title` é o `title` desta Task. |
| **`required`** | Obriga quem cria o objeto a passar aquele valor. Sem `id`, a Task não nasce. |
| **parâmetro nomeado** | Valor passado pelo nome: `title: 'Estudar'`, não só pela ordem. |
| **`factory`** | Construtor especial. Em vez de só criar, ele monta o objeto a partir de dados prontos (`Task.fromJson`). |
| **`fromJson` / `toJson`** | Caminho JSON → objeto e objeto → JSON. |
| **`as`** | “Trate isto como este tipo”. `json['id'] as String`. |
| **`dynamic`** | O Dart ainda não sabe o tipo. Depois do `jsonDecode`, a lista vem como `List<dynamic>`. |
| **`String`** | Texto. `'aluno'`, `'Minhas tarefas'`. |
| **`int`** | Número inteiro. `3`, `72`, `_pendingCount`. |
| **`bool`** | Só `true` ou `false`. `isCompleted`, `darkMode`. |
| **`true` / `false`** | Ligado / desligado. Sim / não. |
| **`DateTime`** | Data e hora. Ano, mês, dia (e hora, se precisar). |
| **`List<Task>`** | Lista (vários itens do mesmo tipo). `[]` é lista vazia. |
| **`Map<String, dynamic>`** | Dicionário: chave (texto) → valor. É o formato do JSON na memória. |
| **`void`** | A função não devolve valor útil. Só “faz alguma coisa”. |
| **`Future`** | “O resultado vem depois.” Usado quando o app espera o disco. |
| **`Future<void>`** | Função demorada que não devolve valor. |
| **`Future<List<Task>>`** | Função demorada que, no fim, devolve uma lista de tarefas. |
| **`async`** | Marca a função como “posso esperar”. Permite usar `await`. |
| **`await`** | Espera o resultado chegar antes de continuar. Não trava a tela. |
| **`final`** | A variável recebe valor uma vez e não troca de objeto. `final String id`. |
| **`const`** | Valor fixo, conhecido na hora de escrever o código. O Flutter reutiliza. |
| **`var`** | O Dart descobre o tipo sozinho. Neste projeto quase não usamos. |
| **`late`** | “Vou preencher daqui a pouco, no `initState`.” Ex.: `_taskDate`. |
| **`static`** | Pertence à classe, não a um objeto. `_storageKey = 'tasks'` é o mesmo para todos. |
| **`_` (underline)** | Privado deste arquivo. `_LoginPageState`, `_tasks`, `_login()`. |
| **`null`** | “Não tem valor.” Gaveta vazia no SharedPreferences. |
| **`?` no tipo** | Pode ser o valor ou `null`. `String? _errorMessage`. |
| **`??`** | “Se for nulo, use isto.” `prefs.getBool(key) ?? false`. |
| **`!` depois do nome** | “Tenho certeza de que não é nulo.” `_errorMessage!`. |
| **`?.`** | Só chama o método se não for nulo. `textTheme.bodyLarge?.copyWith(...)`. |
| **`!` na frente** | Nega o bool. `!isValid` = “se NÃO for válido”. |
| **`&&`** | E. Os dois lados precisam ser verdadeiros. |
| **`\|\|`** | Ou. Basta um lado verdadeiro. |
| **`==` / `!=`** | Igual / diferente. |
| **`? :` (ternário)** | if em uma linha. `_darkMode ? ThemeMode.dark : ThemeMode.light`. |
| **`=>`** | Função curta. `() => _toggleTask(task)` ou `createState() => _HomePageState()`. |
| **`...[]`** | Espalha itens numa lista. `if (erro != null) ...[Text(erro)]`. |
| **`$variavel`** | Encaixa o valor no texto. `'Você tem $_pendingCount tarefas'`. |
| **`return`** | Devolve um valor ou encerra a função agora. |
| **`if` / `else`** | Se / senão. Decide o caminho. |
| **`get`** | Propriedade calculada. Não fica guardada; é montada na hora. `_pendingCount`. |
| **`@override`** | Estamos substituindo um método da classe pai (`build`, `initState`). |
| **`super`** | A classe pai. `super.initState()`, `super.key`, `super.dispose()`. |

---

## 2. Funções e listas

| Termo | O que significa |
|---|---|
| **função** | Bloco com nome que executa um trabalho. `_login()`, `_addTask()`. |
| **parâmetro** | Dado que a função recebe. `_addTask(String title, DateTime date)`. |
| **`trim()`** | Tira espaços do começo e do fim. `" aluno "` vira `"aluno"`. |
| **`isEmpty`** | A string ou a lista não tem nada. |
| **`toString()`** | Transforma número (ou outro valor) em texto. |
| **`padLeft(2, '0')`** | Completa à esquerda. `8` vira `"08"`. |
| **`containsKey`** | “Já existe esta gaveta no SharedPreferences?” |
| **`where`** | Filtra a lista. Só pendentes, só o dia selecionado. |
| **`map`** | Transforma cada item. Cada Map vira uma `Task`. |
| **`toList()`** | Junta o resultado do `where`/`map` em uma `List`. |
| **`add`** | Coloca no final da lista. |
| **`removeWhere`** | Tira da lista quem passar no teste (`item.id == task.id`). |
| **`sort`** | Ordena. `0` = iguais, `1` = vai depois, `-1` = vai antes. |
| **`length`** | Quantos itens a lista tem. |
| **`List.from`** | Copia a lista, sem alterar a original. |
| **`millisecondsSinceEpoch`** | Número grande da data atual; usamos como `id`. |
| **`DateTime.now()`** | Data e hora de agora. |
| **`DateTime.parse`** | Texto ISO → `DateTime`. |
| **`toIso8601String()`** | `DateTime` → texto padrão para JSON. Ex.: `2026-09-08T00:00:00.000`. |
| **`Duration`** | Intervalo. `Duration(days: 1)` = um dia. |
| **`add` / `subtract` em data** | Soma ou tira dias. |

---

## 3. Widgets e ciclo de vida

| Termo | O que significa |
|---|---|
| **`Widget`** | Peça da tela. Tudo que aparece é widget: texto, botão, tela inteira. |
| **árvore de widgets** | Widgets dentro de widgets. `MaterialApp` → `HomePage` → `Column` → `Text`. |
| **`StatelessWidget`** | Widget sem memória própria. Só desenha o que recebeu. `TaskItem`, `EmptyState`. |
| **`StatefulWidget`** | Widget com estado. Os dados mudam enquanto o app está aberto. `HomePage`, `LoginPage`. |
| **`State`** | A parte que guarda os dados do `StatefulWidget`. `_HomePageState`. |
| **`createState()`** | Cria o objeto `State` ligado àquele widget. |
| **estado** | Informação da tela agora: lista de tarefas, data escolhida, tema. |
| **`build`** | Método que **desenha** a tela. O Flutter chama de novo quando precisa atualizar. |
| **`BuildContext` / `context`** | “Endereço” deste widget na árvore. Serve para tema, SnackBar, Navigator. |
| **`setState`** | Avisa o Flutter: os dados mudaram, rode o `build` de novo. |
| **`initState`** | Roda **uma vez**, quando a tela nasce. Lugar de carregar dados. |
| **`dispose`** | Roda quando a tela morre. Lugar de liberar `TextEditingController`. |
| **`didUpdateWidget`** | Roda quando o pai muda os valores (ex.: a Home mudou de dia). |
| **`mounted`** | “Esta tela ainda está na árvore?” Depois de um `await`, pode ter saído. |
| **`widget.`** | Do `State`, acessa o que foi passado para o `StatefulWidget`. `widget.onLogin()`. |
| **`Key` / `super.key`** | Identifica o widget na árvore. O Flutter usa para não misturar peças. |
| **`child`** | Um único filho. `Center(child: Text(...))`. |
| **`children`** | Vários filhos. `Column(children: [...])`. |
| **callback** | Função passada para outro widget. “Quando tocar, me avise.” |
| **`VoidCallback`** | Função sem parâmetros e sem retorno. `onPressed: _login`. |
| **`ValueChanged<T>`** | Função que recebe um valor. `ValueChanged<bool>` no tema. |
| **`void Function(String, DateTime)`** | Função que recebe título e data. `onAdd`. |
| **`onPressed`** | O que acontece ao tocar no botão. |
| **`onChanged`** | O que acontece quando o valor muda (switch, filtro, checkbox). |
| **`onTap`** | Toque numa linha (`ListTile`). |
| **`onSubmitted`** | Enter no teclado. |
| **`onSelected`** | Toque no `FilterChip`. |

---

## 4. Telas, tema e navegação

| Termo | O que significa |
|---|---|
| **`main()`** | Ponto de entrada. O app começa aqui. |
| **`runApp`** | Coloca o widget raiz na tela e inicia o Flutter. |
| **`MaterialApp`** | Configura o app: título, temas, primeira tela. |
| **`home`** | Primeira tela do `MaterialApp`. |
| **`title`** | Nome do app (barra do Windows / lista de apps). |
| **`debugShowCheckedModeBanner`** | A faixa “DEBUG”. `false` esconde. |
| **`ThemeData`** | Visual do tema (claro ou escuro). |
| **`ThemeMode`** | Qual tema usar: `light` ou `dark`. |
| **`ColorScheme`** | Conjunto de cores. `fromSeed` gera o restante a partir de um azul. |
| **`seedColor` / `Color(0xFF1565C0)`** | Cor semente. `FF` = opaco; o resto é o tom. |
| **`Brightness.dark`** | Pedido de cores escuras. |
| **`useMaterial3`** | Liga o visual Material Design 3. |
| **`Theme.of(context)`** | Lê o tema atual desta tela. |
| **`colorScheme`** | Cores do tema: `primary`, `onSurface`, `error`... |
| **`textTheme`** | Estilos de letra: `headlineSmall`, `bodyLarge`... |
| **`copyWith`** | Copia o estilo mudando só um pedaço (negrito, cor). |
| **`FontWeight.bold`** | Negrito. |
| **`Scaffold`** | Estrutura da tela: AppBar, body, fundo. |
| **`AppBar`** | Barra de cima. Título e botões (`actions`). |
| **`body`** | Conteúdo principal da tela. |
| **`actions`** | Botões à direita da AppBar. |
| **`SafeArea`** | Empurra o conteúdo para não ficar atrás do notch / barra de status. |
| **`Navigator`** | Pilha de telas. Empilha e desempilha. |
| **`Navigator.push`** | Abre uma tela em cima (Configurações). |
| **`Navigator.pop`** | Fecha a tela de cima e pode devolver um valor (`true`/`false`). |
| **`MaterialPageRoute`** | Caminho padrão para abrir outra página. |
| **`showDialog`** | Abre um diálogo (excluir, sair, senha). |
| **`AlertDialog`** | Caixa com título, texto e botões. |
| **`showDatePicker`** | Calendário nativo. Devolve a data ou `null` se cancelar. |
| **`SnackBar`** | Faixa de recado na parte de baixo. |
| **`ScaffoldMessenger`** | Quem mostra o `SnackBar`. `of(context).showSnackBar(...)`. |
| **`CircularProgressIndicator`** | Rodinha de “carregando”. |
| **`tooltip`** | Texto ao passar o mouse (útil no Windows). |

---

## 5. Layout

| Termo | O que significa |
|---|---|
| **`Column`** | Empilha de cima para baixo. |
| **`Row`** | Coloca lado a lado. |
| **`Expanded`** | Ocupa o espaço que sobrar na `Row`/`Column`. |
| **`Padding`** | Espaço **interno**, em volta do filho. |
| **`EdgeInsets`** | Medidas do padding/margin. `all(24)`, `fromLTRB`, `symmetric`. |
| **`margin`** | Espaço **fora** do cartão. |
| **`SizedBox`** | Caixa só para ocupar espaço (`height: 16`) ou forçar tamanho. |
| **`Center`** | Centraliza o filho. |
| **`Align`** | Alinha (esquerda, direita, etc.). |
| **`ConstrainedBox`** | Limita tamanho. `maxWidth: 400` no login (Windows). |
| **`SingleChildScrollView`** | Permite rolar um conteúdo só (teclado, janela baixa). |
| **`ListView`** | Lista rolável. |
| **`ListView.builder`** | Cria os itens sob demanda. `itemCount` + `itemBuilder`. |
| **`itemCount`** | Quantos itens a lista tem. |
| **`itemBuilder`** | Função chamada para cada posição (`index`). |
| **`index`** | Posição: 0, 1, 2... |
| **`mainAxisSize: min`** | A coluna só tem a altura dos filhos, não estica. |
| **`crossAxisAlignment`** | Alinhamento no eixo cruzado (em `Column`, é horizontal). |
| **`mainAxisAlignment`** | Alinhamento no eixo principal. |
| **`double.infinity`** | “Ocupe a largura (ou altura) inteira do pai.” |

---

## 6. Peças visuais deste app

| Termo | O que significa |
|---|---|
| **`Text`** | Mostra uma frase. |
| **`TextAlign`** | Alinha o texto (`center`). |
| **`TextStyle`** | Cor, tamanho, peso da letra. |
| **`TextDecoration.lineThrough`** | Texto riscado (tarefa concluída). |
| **`Icon`** | Desenho do Material Icons. |
| **`Icons.check_circle_outline`** | Ícone de “certo” com círculo. |
| **`IconButton`** | Botão que é só um ícone (lixeira, engrenagem, seta). |
| **`TextField`** | Caixinha para digitar. |
| **`TextEditingController`** | Lê e apaga o texto do `TextField`. |
| **`.text`** | O que está digitado no controller. |
| **`.clear()`** | Esvazia o campo. |
| **`obscureText`** | Esconde a senha com bolinhas. |
| **`textInputAction`** | Tecla do teclado: `next` (próximo campo) ou `done` (Enter). |
| **`InputDecoration`** | Visual do campo: rótulo, dica, borda. |
| **`labelText`** | Nome do campo (sobe quando digita). |
| **`hintText`** | Exemplo cinza no campo vazio. |
| **`OutlineInputBorder`** | Retângulo com borda. |
| **`BorderRadius.circular`** | Cantos arredondados. |
| **`contentPadding`** | Espaço do texto **dentro** da caixinha. |
| **`FilledButton`** | Botão preenchido (ENTRAR, ADICIONAR, Excluir). |
| **`OutlinedButton` / `OutlinedButton.icon`** | Botão só com contorno (data). |
| **`TextButton`** | Botão só texto (Cancelar). |
| **`FilterChip`** | Botãozinho selecionável (Todas / Pendentes / Concluídas). |
| **`SwitchListTile`** | Linha com texto + interruptor. |
| **`ListTile`** | Linha: ícone, título, setinha. |
| **`leading` / `title` / `trailing`** | Esquerda / meio / direita do `ListTile`. |
| **`Card`** | Retângulo com fundo separado (item da tarefa, resumo). |
| **`Checkbox`** | Caixinha de marcar. |
| **`value`** | Valor atual (marcado, interruptor ligado, chip selecionado). |

---

## 7. Persistência e JSON

| Termo | O que significa |
|---|---|
| **JSON** | Texto para guardar dados. O disco não entende objeto Dart. |
| **`jsonEncode`** | Objeto/lista → texto JSON. |
| **`jsonDecode`** | Texto JSON → lista/mapa na memória. |
| **`dart:convert`** | Biblioteca do `jsonEncode` / `jsonDecode`. |
| **`SharedPreferences`** | Armazenamento local simples (chave → valor). Sem banco, sem internet. |
| **`getInstance()`** | Pede ao sistema o acesso a esse armazenamento. |
| **chave** | Nome da “gaveta”. `'tasks'`, `'isLoggedIn'`, `'password'`. |
| **`getString` / `setString`** | Lê / grava texto. |
| **`getBool` / `setBool`** | Lê / grava verdadeiro/falso. |
| **offline** | Funciona sem internet. Os dados ficam no aparelho. |

---

## 8. Ideias da aula

| Termo | O que significa |
|---|---|
| **Clean Architecture (versão didática)** | Pastas com responsabilidade: `models`, `services`, `pages`, `widgets`. |
| **model** | Molde dos dados. `Task`, `AppSettings`. |
| **service** | Fala com o disco. `TaskStorage`, `AppStorage`. |
| **page** | Tela inteira. Login, Home, Configurações. |
| **widget reutilizável** | Pedaço de tela. `TaskItem`, `TaskInput`. |
| **login local** | Usuário e senha no aparelho. Sem servidor, sem token, sem hash (só didático). |
| **`isLoggedIn`** | Flag: o aluno já entrou e ainda não saiu. |
| **hot reload (`r`)** | Recarrega a tela sem fechar o app. |
| **APK** | Arquivo para instalar no Android. |
| **overflow** | Conteúdo maior que o espaço. A tela “estoura”. |
