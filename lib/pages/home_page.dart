import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/app_storage.dart';
import '../services/task_storage.dart';
import '../widgets/empty_state.dart';
import '../widgets/task_filter.dart';
import '../widgets/task_input.dart';
import '../widgets/task_item.dart';
import 'settings_page.dart';

// HomePage é a tela principal e também guarda o ESTADO da lista.
// StatefulWidget é usado porque os dados mudam enquanto o app está aberto:
// adicionar, concluir e excluir tarefas.
class HomePage extends StatefulWidget {
  final VoidCallback onLogout;
  final ValueChanged<bool> onThemeChanged;

  const HomePage({
    super.key,
    required this.onLogout,
    required this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TaskStorage _storage = TaskStorage();
  final AppStorage _appStorage = AppStorage();

  // Lista em memória. É ela que a interface mostra na tela.
  List<Task> _tasks = [];

  // Data atualmente selecionada pelo usuário.
  DateTime _selectedDate = dateOnly(DateTime.now());

  // O filtro define quais tarefas serão mostradas.
  String _selectedFilter = 'all';

  bool _confirmDelete = true;

  // Enquanto os dados estão sendo lidos do celular, mostramos um loading.
  bool _isLoading = true;

  // Os indicadores usam só as tarefas do dia selecionado,
  // e não a lista inteira do aplicativo.
  List<Task> get _tasksOnSelectedDate {
    return _tasks
        .where((task) => isSameDay(task.date, _selectedDate))
        .toList();
  }

  List<Task> get _visibleTasks {
    final ofDay = _tasksOnSelectedDate;
    List<Task> filtered;

    if (_selectedFilter == 'pending') {
      filtered = ofDay.where((task) => !task.isCompleted).toList();
    } else if (_selectedFilter == 'completed') {
      filtered = ofDay.where((task) => task.isCompleted).toList();
    } else {
      filtered = List<Task>.from(ofDay);
    }

    // Pendentes primeiro, concluídas depois.
    // sort é estável, então a ordem de criação é mantida em cada grupo.
    filtered.sort((a, b) {
      if (a.isCompleted == b.isCompleted) {
        return 0;
      }
      return a.isCompleted ? 1 : -1;
    });

    return filtered;
  }

  int get _pendingCount =>
      _tasksOnSelectedDate.where((task) => !task.isCompleted).length;

  int get _completedCount =>
      _tasksOnSelectedDate.where((task) => task.isCompleted).length;

  String get _dayTitle {
    final today = dateOnly(DateTime.now());
    if (isSameDay(_selectedDate, today)) {
      return 'Hoje';
    }
    if (isSameDay(_selectedDate, today.subtract(const Duration(days: 1)))) {
      return 'Ontem';
    }
    if (isSameDay(_selectedDate, today.add(const Duration(days: 1)))) {
      return 'Amanhã';
    }
    return 'Tarefas do dia';
  }

  String get _longDateLabel {
    const months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro',
    ];
    return '${_selectedDate.day} de ${months[_selectedDate.month - 1]} de ${_selectedDate.year}';
  }

  String get _emptyMessage {
    if (_selectedFilter == 'pending') {
      return 'Nenhuma tarefa pendente neste dia.';
    }
    if (_selectedFilter == 'completed') {
      return 'Nenhuma tarefa concluída neste dia.';
    }
    return 'Você ainda não possui tarefas neste dia.\nAdicione uma tarefa para começar.';
  }

  String get _pendingMessage {
    if (_pendingCount == 1) {
      return 'Você tem 1 tarefa pendente';
    }
    return 'Você tem $_pendingCount tarefas pendentes';
  }

  // initState roda uma vez, quando a tela nasce.
  // É o momento certo para carregar as tarefas salvas.
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedTasks = await _storage.loadTasks();
    final settings = await _appStorage.loadSettings();

    // setState avisa ao Flutter que os dados mudaram
    // e que a interface precisa ser desenhada novamente.
    setState(() {
      _tasks = loadedTasks;
      _confirmDelete = settings.confirmDelete;
      _isLoading = false;
    });
  }

  Future<void> _saveTasks() async {
    await _storage.saveTasks(_tasks);
  }

  Future<void> _addTask(String title, DateTime date) async {
    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      date: dateOnly(date),
    );

    setState(() {
      _tasks.add(task);
      _selectedDate = dateOnly(date);
    });

    await _saveTasks();
  }

  Future<void> _toggleTask(Task task) async {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });

    await _saveTasks();
  }

  Future<void> _deleteTask(Task task) async {
    if (_confirmDelete) {
      final shouldDelete = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Excluir tarefa?'),
            content: const Text(
              'Tem certeza que deseja excluir esta tarefa?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Excluir'),
              ),
            ],
          );
        },
      );

      if (shouldDelete != true) {
        return;
      }
    }

    setState(() {
      _tasks.removeWhere((item) => item.id == task.id);
    });
    await _saveTasks();
  }

  void _changeDate(DateTime date) {
    setState(() {
      _selectedDate = dateOnly(date);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      _changeDate(picked);
    }
  }

  Future<void> _openSettings() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SettingsPage(
            onLogout: widget.onLogout,
            onThemeChanged: widget.onThemeChanged,
          );
        },
      ),
    );

    final settings = await _appStorage.loadSettings();
    if (!mounted) {
      return;
    }
    setState(() {
      _confirmDelete = settings.confirmDelete;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas tarefas'),
        actions: [
          IconButton(
            tooltip: 'Configurações',
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(child: _buildContent()),
                TaskInput(
                  selectedDate: _selectedDate,
                  onAdd: _addTask,
                ),
              ],
            ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _dayTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              _longDateLabel,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 4),
            Text(
              _pendingMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateNav() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Dia anterior',
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              _changeDate(_selectedDate.subtract(const Duration(days: 1)));
            },
          ),
          Expanded(
            child: TextButton.icon(
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today),
              label: Text(formatShortDate(_selectedDate)),
            ),
          ),
          IconButton(
            tooltip: 'Próximo dia',
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              _changeDate(_selectedDate.add(const Duration(days: 1)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: _SummaryCard(
              label: 'Pendentes',
              count: _pendingCount,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SummaryCard(
              label: 'Concluídas',
              count: _completedCount,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_visibleTasks.isEmpty) {
      // Com lista vazia, tudo vai em um ListView para caber
      // também em janelas baixas, como no navegador.
      return ListView(
        children: [
          _buildHeader(context),
          _buildDateNav(),
          TaskFilter(
            selectedFilter: _selectedFilter,
            onChanged: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
          ),
          _buildIndicators(context),
          EmptyState(message: _emptyMessage),
        ],
      );
    }

    return Column(
      children: [
        _buildHeader(context),
        _buildDateNav(),
        TaskFilter(
          selectedFilter: _selectedFilter,
          onChanged: (value) {
            setState(() {
              _selectedFilter = value;
            });
          },
        ),
        _buildIndicators(context),
        Expanded(child: _buildTaskList()),
      ],
    );
  }

  Widget _buildTaskList() {
    final visibleTasks = _visibleTasks;

    // ListView.builder cria os itens sob demanda.
    // Isso é mais eficiente do que desenhar todos de uma vez.
    return ListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      itemCount: visibleTasks.length,
      itemBuilder: (context, index) {
        final task = visibleTasks[index];

        return TaskItem(
          task: task,
          onToggle: () => _toggleTask(task),
          onDelete: () => _deleteTask(task),
        );
      },
    );
  }
}

// Pequeno card de resumo usado só nesta página.
class _SummaryCard extends StatelessWidget {
  final String label;
  final int count;

  const _SummaryCard({
    required this.label,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      color: colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '$count',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
