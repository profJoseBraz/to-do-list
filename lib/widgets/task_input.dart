// material.dart traz TextField, botões e o calendário (showDatePicker).
import 'package:flutter/material.dart';

// Usamos dateOnly, isSameDay e formatShortDate que estão em task.dart.
import '../models/task.dart';

// TaskInput é a barra de baixo: campo de texto + data + botão ADICIONAR.
// StatefulWidget porque o texto e a data escolhida mudam.
class TaskInput extends StatefulWidget {
  // Data que a Home está mostrando. O campo começa com esse dia.
  final DateTime selectedDate;
  // Função que a Home passou. Recebe o título e a data da nova tarefa.
  final void Function(String title, DateTime date) onAdd;

  const TaskInput({
    super.key,
    required this.selectedDate,
    required this.onAdd,
  });

  @override
  State<TaskInput> createState() => _TaskInputState();
}

// Estado do campo: controller do texto e data escolhida para a nova tarefa.
class _TaskInputState extends State<TaskInput> {
  // Lê o que o aluno digitou no TextField.
  final TextEditingController _controller = TextEditingController();
  // late = vamos preencher este valor no initState, não agora.
  late DateTime _taskDate;

  // initState roda uma vez, quando este widget nasce.
  @override
  void initState() {
    super.initState();
    // Começa com o dia que a Home está mostrando, sem hora.
    _taskDate = dateOnly(widget.selectedDate);
  }

  // didUpdateWidget roda quando a Home muda de valores
  // (por exemplo, o aluno foi para amanhã na seta de data).
  @override
  void didUpdateWidget(TaskInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se o dia da Home mudou, o campo acompanha.
    if (!isSameDay(oldWidget.selectedDate, widget.selectedDate)) {
      _taskDate = dateOnly(widget.selectedDate);
    }
  }

  // dispose libera o controller quando o widget sai da tela.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Abre o calendário nativo do Flutter.
  Future<void> _pickDate() async {
    // showDatePicker devolve a data escolhida, ou null se o aluno cancelar.
    final picked = await showDatePicker(
      context: context,
      // Dia que já está selecionado no botão.
      initialDate: _taskDate,
      // Primeiro dia que o calendário aceita.
      firstDate: DateTime(2020),
      // Último dia que o calendário aceita.
      lastDate: DateTime(2100),
    );

    // Se o aluno escolheu um dia (não cancelou)...
    if (picked != null) {
      setState(() {
        // Guardamos só a data, sem hora.
        _taskDate = dateOnly(picked);
      });
    }
  }

  // Chamado pelo botão ADICIONAR ou pela tecla Enter.
  void _submit() {
    // trim tira espaços do começo e do fim.
    final title = _controller.text.trim();

    // isEmpty = o aluno não digitou nada útil.
    if (title.isEmpty) {
      // SnackBar avisa na parte de baixo da tela.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite uma tarefa antes de adicionar.'),
        ),
      );
      // return para não criar tarefa vazia.
      return;
    }

    // Entrega título e data para a Home criar a Task.
    widget.onAdd(title, _taskDate);
    // Limpa o campo para a próxima tarefa.
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    // Material dá cor de fundo e uma sombra leve (elevation).
    return Material(
      elevation: 3,
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        // padding interno: 16 nas laterais, 12 em cima e embaixo.
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            // mainAxisSize.min = a coluna só ocupa a altura dos filhos.
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                // done = tecla Enter significa "terminei".
                textInputAction: TextInputAction.done,
                // (_) ignora o texto recebido e chama _submit.
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  labelText: 'Tarefa',
                  hintText: 'Nova tarefa',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Espaço interno do texto dentro da caixinha.
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Row coloca o botão da data e o ADICIONAR lado a lado.
              Row(
                children: [
                  // Expanded faz o botão da data ocupar o espaço que sobrar.
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today),
                      // Mostra a data no formato 08/09/2026.
                      label: Text(formatShortDate(_taskDate)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      // Tamanho mínimo para ficar fácil de clicar.
                      minimumSize: const Size(120, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('ADICIONAR'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
