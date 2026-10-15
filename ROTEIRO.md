# Roteiro de aula — ToDo List Flutter

Ordem para construir o app **do zero** em sala (Windows) e gerar o APK depois.

Regra: **quem é importado nasce primeiro**. O `main.dart` pronto é o **último** arquivo a fechar, não o primeiro.

Este arquivo pode ser aberto em qualquer editor, impresso ou compartilhado pelo GitHub. Não depende do Cursor.

---

## 1. Ambiente (cada computador da sala)

1. Instalar Flutter SDK e VS Code (extensões Dart e Flutter).
2. Ativar o **Modo de desenvolvedor** do Windows  
   Configurações → Privacidade e segurança → Para desenvolvedores  
   ou no terminal: `start ms-settings:developers`  
   Sem isso o `shared_preferences` falha no Windows.
3. Conferir o ambiente:

```bash
flutter doctor
flutter devices
```

Tem que aparecer `Windows (desktop)`. Se o doctor pedir licenças:

```bash
flutter doctor --android-licenses
```

---

## 2. Criar o projeto

```bash
flutter create --org com.didatico --project-name todo_list --platforms android,windows todo_list
cd todo_list
flutter pub get
flutter run -d windows
```

Deve abrir o app do **contador**. Isso prova que o ambiente está pronto.

Não edite `android/` nem `windows/`. A turma só mexe em `lib/` e, na persistência, no `pubspec.yaml`.

Crie as pastas (ainda vazias, menos o `main` temporário):

```text
lib/
├── main.dart
├── models/
├── pages/
├── widgets/
└── services/
```

---

## 3. Dependências (quem importa quem)

A seta significa **é usado por**. O que está em cima se escreve primeiro.

```text
task.dart
app_settings.dart
empty_state.dart
task_filter.dart
        ↓
task_storage.dart
app_storage.dart
task_item.dart
task_input.dart
        ↓
login_page.dart
settings_page.dart
        ↓
home_page.dart   (vai crescendo ao longo das aulas)
        ↓
main.dart final  ← último
```

| Arquivo | Importa do projeto | Quando criar |
|---|---|---|
| `models/task.dart` | — | Primeiro arquivo de verdade |
| `models/app_settings.dart` | — | Antes do `AppStorage` |
| `widgets/empty_state.dart` | — | Quando tratar lista vazia |
| `widgets/task_filter.dart` | — | Na etapa de data e filtro |
| `services/task_storage.dart` | `task.dart` | Depois da `Task` |
| `services/app_storage.dart` | `app_settings.dart` | Depois do `AppSettings` |
| `widgets/task_item.dart` | `task.dart` | Depois da `Task` |
| `widgets/task_input.dart` | `task.dart` | Depois da `Task` |
| `pages/login_page.dart` | `app_storage.dart` | Depois do `AppStorage` |
| `pages/settings_page.dart` | `app_storage.dart` | Depois do `AppStorage` |
| `pages/home_page.dart` | Task, storages, widgets, Settings | Vai crescendo; completa no fim |
| `main.dart` final | Home, Login, AppStorage | **Último** a fechar |

O `main.dart` **pronto** importa `HomePage`, `LoginPage` e `AppStorage`. Se você escrevê-lo no primeiro dia, o projeto **não compila**.

---

## 4. Ordem dos arquivos (respeitando as dependências)

### 0. `main.dart` temporário

- **Precisa existir antes:** ninguém.
- Escreva `MaterialApp` + `Scaffold` + AppBar “Minhas tarefas” **no mesmo arquivo**.
- Zero imports de `pages/`, `models/` ou `services/`.
- Serve só para o app rodar. Será reescrito na etapa 16.

### 1. `lib/models/task.dart`

- **Precisa existir antes:** ninguém.
- `id`, `title`, `isCompleted`. Construtor, `toJson` e `fromJson`.
- Sem data ainda.

### 2. `lib/pages/home_page.dart` — só memória

- **Precisa existir antes:** `task.dart`.
- `StatefulWidget`, `List<Task>`, `setState`.
- Sem widgets separados.
- No main temporário: `home: HomePage()`.

### 3. `lib/widgets/task_item.dart`

- **Precisa existir antes:** `task.dart`.
- Checkbox, título, excluir. A Home passa os callbacks.

### 4. HomePage — `ListView.builder`

- **Precisa existir antes:** `task.dart` e `task_item.dart`.
- Explique `itemCount` e `itemBuilder`.

### 5. `lib/widgets/task_input.dart`

- **Precisa existir antes:** no começo, ninguém (só devolve o texto).
- `TextEditingController`, `trim`, SnackBar se vazio.
- A Home cria a `Task`. Data entra na etapa 10.

### 6. `lib/widgets/empty_state.dart`

- **Precisa existir antes:** ninguém.
- Só Flutter. A Home importa quando tratar lista vazia.

### 7. HomePage — concluir e excluir

- **Precisa existir antes:** `task_item.dart` e `empty_state.dart`.
- Inverter `isCompleted`, `showDialog` na exclusão, `EmptyState` se zerar a lista.

### 8. `lib/services/task_storage.dart`

- **Precisa existir antes:** `task.dart`.
- `flutter pub add shared_preferences`
- `loadTasks` e `saveTasks`. Ainda não ligue na Home.

### 9. HomePage — carregar e salvar

- **Precisa existir antes:** `task_storage.dart`.
- `initState` chama `loadTasks`. Cada alteração chama `saveTasks`.

### 10. Data e filtro

- **Precisa existir antes:** `Task`, `TaskInput` e `Home`.
- Ordem interna: campo `date` na `Task` → `task_filter.dart` → atualizar Home e `TaskInput`.
- Tarefa antiga sem data: `DateTime.now()`.

### 11. `lib/models/app_settings.dart`

- **Precisa existir antes:** ninguém.
- `darkMode` e `confirmDelete`.

### 12. `lib/services/app_storage.dart`

- **Precisa existir antes:** `app_settings.dart`.
- Login local (`aluno` / `1234`), senha e preferências. Ainda sem tela.

### 13. `lib/pages/login_page.dart`

- **Precisa existir antes:** `app_storage.dart`.
- Ainda não ligue no `main`.

### 14. `lib/pages/settings_page.dart`

- **Precisa existir antes:** `app_storage.dart`.
- Tema, confirmar exclusão, senha e logout.

### 15. HomePage — botão de configurações

- **Precisa existir antes:** `settings_page.dart` e `app_storage.dart`.
- `Navigator.push`. Relê `confirmDelete` ao voltar.

### 16. `main.dart` final

- **Precisa existir antes:** `home_page.dart`, `login_page.dart` e `app_storage.dart`.
- `TodoApp` como `StatefulWidget`: lê `isLoggedIn` e `darkMode`, escolhe Login ou Home, aplica `ThemeMode`.

---

## 5. Depois (não é a primeira aula)

```bash
flutter run -d windows
```

Hot reload: `r` no terminal.

Quando for testar no celular:

```bash
flutter run
flutter build apk
```

O APK sai em `build/app/outputs/flutter-apk/app-release.apk`.

Login do app pronto: **aluno** / **1234**.
