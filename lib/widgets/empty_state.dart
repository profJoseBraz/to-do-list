// material.dart traz Icon, Text, Padding e Column.
import 'package:flutter/material.dart';

// EmptyState aparece quando não há tarefas para mostrar.
// StatelessWidget: só desenha a mensagem que recebeu. Não guarda lista.
class EmptyState extends StatelessWidget {
  // Texto de baixo. A Home muda conforme o filtro (todas / pendentes / concluídas).
  final String message;

  const EmptyState({
    super.key,
    // Se a Home não passar mensagem, usamos este texto padrão.
    this.message =
        'Você ainda não possui tarefas.\nAdicione uma tarefa para começar.',
  });

  @override
  Widget build(BuildContext context) {
    // Cores do tema (azul principal, texto mais fraco...).
    final colorScheme = Theme.of(context).colorScheme;
    // Estilos de letra do tema.
    final textTheme = Theme.of(context).textTheme;

    // Padding cria um espaço de 32 pixels em volta do conteúdo.
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        // min = a coluna não estica até o fim da tela; só o tamanho do conteúdo.
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            // Ícone de "certo" com círculo, do Material Icons.
            Icons.check_circle_outline,
            size: 72,
            color: colorScheme.primary,
          ),
          // Espaço entre o ícone e o título.
          const SizedBox(height: 16),
          Text(
            'Tudo organizado!',
            style: textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            // textAlign centraliza se a frase quebrar em duas linhas.
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            // Aqui entra a mensagem dinâmica da Home.
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              // Cor mais suave para o texto de apoio.
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
