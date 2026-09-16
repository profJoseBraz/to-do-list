import 'package:flutter/material.dart';

// EmptyState aparece quando a lista ainda não tem nenhuma tarefa.
// Em vez de deixar a tela em branco, mostramos uma mensagem amigável.
class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({
    super.key,
    this.message =
        'Você ainda não possui tarefas.\nAdicione uma tarefa para começar.',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 72,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Tudo organizado!',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
