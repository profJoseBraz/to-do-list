import 'package:flutter/material.dart';

import '../models/task.dart';

// TaskItem desenha UMA tarefa da lista.
// Ele não guarda a lista inteira: só recebe a tarefa e avisa a HomePage
// quando o aluno marca, desmarca ou exclui.
class TaskItem extends StatelessWidget {
  final Task task;

  // Callback: uma função passada pelo widget pai.
  // Quando o aluno toca no checkbox, chamamos onToggle.
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isCompleted = task.isCompleted;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: ListTile(
        leading: Checkbox(
          value: isCompleted,
          onChanged: (_) => onToggle(),
        ),
        title: Text(
          task.title,
          style: textTheme.bodyLarge?.copyWith(
            // Tarefa concluída fica riscada e com menos ênfase,
            // mas continua visível na lista.
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted
                ? colorScheme.onSurface.withValues(alpha: 0.45)
                : colorScheme.onSurface,
          ),
        ),
        trailing: IconButton(
          tooltip: 'Excluir tarefa',
          icon: const Icon(Icons.delete_outline),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
