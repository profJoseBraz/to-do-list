# ToDo List

Aplicativo de lista de tarefas criado em Flutter para uso didático no 1º ano do Ensino Médio do curso Técnico em Desenvolvimento de Sistemas.

O objetivo é construir um primeiro projeto Flutter completo: simples de explicar em sala, com aparência profissional e funcionamento real no celular.

## Objetivo

Permitir que o aluno:

- entrar com login local (`aluno` / `1234`);
- visualizar tarefas por data;
- adicionar uma nova tarefa em um dia escolhido;
- marcar uma tarefa como concluída;
- filtrar por Todas, Pendentes e Concluídas;
- excluir uma tarefa;
- alterar senha, tema e preferências;
- fechar o aplicativo e encontrar os dados salvos no próximo acesso.

Tudo isso funciona **offline**, sem banco de dados e sem backend.

## Tecnologias utilizadas

- Flutter
- Dart
- Material 3
- `shared_preferences`

Não há Firebase, SQLite, API, servidor ou gerenciador de estado avançado. O estado da tela usa `StatefulWidget` e `setState`.

## Arquitetura de pastas

A organização segue uma versão simples e didática de Clean Architecture:

```text
lib/
├── main.dart
├── models/
│   ├── task.dart
│   └── app_settings.dart
├── services/
│   ├── task_storage.dart
│   └── app_storage.dart
├── pages/
│   ├── login_page.dart
│   ├── home_page.dart
│   └── settings_page.dart
└── widgets/
    ├── task_item.dart
    ├── task_input.dart
    ├── empty_state.dart
    └── task_filter.dart
```

Responsabilidades:

- `main.dart`: inicia o app, o tema e decide entre Login e Home;
- `models/task.dart`: representa uma tarefa (incluindo a data) e converte para JSON;
- `models/app_settings.dart`: preferências simples (tema e confirmação de exclusão);
- `services/task_storage.dart`: salva e carrega as tarefas no celular;
- `services/app_storage.dart`: login local e configurações;
- `pages/`: telas de login, lista e configurações;
- `widgets/`: pedaços reutilizáveis da tela.

## Como funciona a persistência

As tarefas são convertidas para JSON e armazenadas localmente com `shared_preferences`.

```text
Lista de tarefas
       ↓
Objeto Task
       ↓
JSON
       ↓
SharedPreferences
       ↓
Armazenamento do celular
```

Ao abrir o aplicativo:

```text
SharedPreferences
       ↓
JSON
       ↓
Lista de Task
       ↓
Interface
```

Não é necessário internet. Os dados ficam no próprio aparelho.

## Como executar

Na pasta do projeto:

```bash
flutter pub get
```

No computador, sem celular:

```bash
flutter run -d chrome
```

No Windows (é preciso ativar o Modo de Desenvolvedor do Windows):

```bash
flutter run -d windows
```

No celular Android, conecte o aparelho com a depuração USB ativada ou use um emulador:

```bash
flutter run
```

## Como gerar APK

Para instalar em celulares Android:

```bash
flutter build apk
```

O arquivo gerado fica em:

```text
build/app/outputs/flutter-apk/app-release.apk
```

Depois, transfira o APK para o celular e instale.

## Caminho sugerido para a aula

1. Criar o projeto Flutter.
2. Criar a classe `Task`.
3. Criar uma lista de tarefas em memória.
4. Montar a interface básica.
5. Mostrar as tarefas com `ListView.builder`.
6. Criar o campo para adicionar tarefa.
7. Implementar a conclusão da tarefa.
8. Implementar a exclusão.
9. Criar o `TaskStorage`.
10. Adicionar `shared_preferences`.
11. Salvar e carregar JSON.
12. Melhorar o design.
13. Testar no celular.
14. Gerar o APK.

## Conceitos aprendidos

- Flutter
- Dart
- Widgets
- StatefulWidget
- setState
- navegação entre telas
- ListView.builder
- TextEditingController
- classes e objetos
- DateTime
- filtros
- JSON
- armazenamento local
- SharedPreferences
- async/await
- Future
- ThemeMode
- Clean Code
- organização de projeto
