// material.dart traz Scaffold, Switch, ListTile, diálogo e SnackBar.
import 'package:flutter/material.dart';

// AppStorage lê e grava tema, senha e "estou logado".
import '../services/app_storage.dart';

// SettingsPage reúne as preferências simples do aplicativo.
class SettingsPage extends StatefulWidget {
  // Avisa o TodoApp para voltar ao login.
  final VoidCallback onLogout;
  // Avisa o TodoApp que o interruptor de tema mudou.
  final ValueChanged<bool> onThemeChanged;

  const SettingsPage({
    super.key,
    required this.onLogout,
    required this.onThemeChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AppStorage _appStorage = AppStorage();
  // true enquanto as preferências estão sendo lidas.
  bool _isLoading = true;
  bool _darkMode = false;
  bool _confirmDelete = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _appStorage.loadSettings();
    setState(() {
      _darkMode = settings.darkMode;
      _confirmDelete = settings.confirmDelete;
      _isLoading = false;
    });
  }

  // Ligar/desligar o modo escuro.
  Future<void> _toggleDarkMode(bool value) async {
    setState(() {
      _darkMode = value;
    });
    // Grava no aparelho para a próxima abertura.
    await _appStorage.saveDarkMode(value);
    // Avisa o TodoApp para trocar ThemeMode agora.
    widget.onThemeChanged(value);
  }

  // Ligar/desligar a pergunta antes de excluir.
  Future<void> _toggleConfirmDelete(bool value) async {
    setState(() {
      _confirmDelete = value;
    });
    await _appStorage.saveConfirmDelete(value);
  }

  // Mostra o diálogo "Deseja sair da conta?".
  Future<void> _confirmLogout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmação'),
          content: const Text('Deseja sair da conta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );

    // Só continua se o aluno tocou em Sair.
    if (shouldLogout == true) {
      // Marca isLoggedIn = false. As tarefas continuam salvas.
      await _appStorage.setLoggedIn(false);
      if (!mounted) {
        return;
      }
      // Fecha a SettingsPage (volta para a Home por um instante).
      Navigator.pop(context);
      // TodoApp troca a Home pela LoginPage.
      widget.onLogout();
    }
  }

  Future<void> _changePassword() async {
    // O diálogo devolve true só depois de salvar a senha.
    // A mensagem de sucesso aparece DEPOIS, com o diálogo já fechado.
    final changed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return _ChangePasswordDialog(appStorage: _appStorage);
      },
    );

    // && = as duas coisas precisam ser verdadeiras.
    if (changed == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Senha alterada com sucesso!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const _SectionTitle('APARÊNCIA'),
                // SwitchListTile é uma linha com texto + interruptor.
                SwitchListTile(
                  title: const Text('Modo escuro'),
                  // Operador ternário escolhe o subtítulo.
                  subtitle: Text(_darkMode ? '🌙 Ativado' : '☀️ Desativado'),
                  value: _darkMode,
                  onChanged: _toggleDarkMode,
                ),
                const _SectionTitle('TAREFAS'),
                SwitchListTile(
                  title: const Text('Confirmar exclusão'),
                  subtitle: const Text(
                    'Pedir confirmação antes de apagar uma tarefa',
                  ),
                  value: _confirmDelete,
                  onChanged: _toggleConfirmDelete,
                ),
                const _SectionTitle('CONTA'),
                ListTile(
                  title: const Text('Alterar senha'),
                  // chevron_right é a setinha > da direita.
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _changePassword,
                ),
                ListTile(
                  title: const Text('Sair da conta'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _confirmLogout,
                ),
                const _SectionTitle('SOBRE'),
                const ListTile(
                  title: Text('Minhas Tarefas'),
                  subtitle: Text('Versão 1.0.0'),
                ),
              ],
            ),
    );
  }
}

// Diálogo de alterar senha. StatefulWidget porque os campos e o erro mudam.
class _ChangePasswordDialog extends StatefulWidget {
  final AppStorage appStorage;

  const _ChangePasswordDialog({
    required this.appStorage,
  });

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  // Três controllers: senha atual, nova e confirmação.
  final TextEditingController _currentController = TextEditingController();
  final TextEditingController _newController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();
  // String? pode ser um texto ou null (sem erro).
  String? _errorMessage;
  // true enquanto estamos gravando, para travar os botões.
  bool _isSaving = false;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final current = _currentController.text.trim();
    final next = _newController.text.trim();
    final confirm = _confirmController.text.trim();
    // Senha que está gravada hoje no aparelho.
    final savedPassword = await widget.appStorage.loadPassword();

    if (!mounted) {
      return;
    }

    if (current != savedPassword) {
      setState(() {
        _errorMessage = 'Senha atual incorreta.';
      });
      return;
    }

    if (next.isEmpty) {
      setState(() {
        _errorMessage = 'A nova senha não pode ficar vazia.';
      });
      return;
    }

    if (next != confirm) {
      setState(() {
        _errorMessage = 'A confirmação não confere com a nova senha.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      // null esconde a mensagem vermelha.
      _errorMessage = null;
    });

    await widget.appStorage.savePassword(next);
    if (!mounted) {
      return;
    }
    // pop fecha o diálogo e devolve true para a SettingsPage.
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Alterar senha'),
      content: SingleChildScrollView(
        child: Column(
          // min = a coluna só tem a altura dos campos.
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha atual',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _newController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nova senha',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar nova senha',
              ),
            ),
            // if (... ) ...[ ] só inclui estes widgets se houver erro.
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                // ! avisa: aqui já sabemos que não é null.
                _errorMessage!,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          // null no onPressed desativa o botão enquanto salva.
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _save,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

// Título de seção (APARÊNCIA, TAREFAS...). Widget privado deste arquivo.
class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }
}
