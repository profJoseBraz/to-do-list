// material.dart traz Card, ListTile, Checkbox, Text, IconButton...
import 'package:flutter/material.dart';

// Precisamos do molde Task para receber a tarefa que vamos desenhar.
import '../models/task.dart';

// TaskItem desenha UMA tarefa da lista.
// StatelessWidget: ele não guarda a lista. Só mostra o que recebeu.
// Quando o aluno toca, avisa a HomePage pelas funções onToggle e onDelete.
class TaskItem extends StatelessWidget {
  // A tarefa que este cartão representa.
  final Task task;

  // VoidCallback = função sem parâmetros e sem retorno.
  // onToggle é chamada quando o aluno marca ou desmarca o checkbox.
  final VoidCallback onToggle;
  // onDelete é chamada quando o aluno toca na lixeira.
  final VoidCallback onDelete;

  // Construtor. required obriga a Home a passar os três valores.
  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
  });

  // build desenha este item.
  @override
  Widget build(BuildContext context) {
    // Cores do tema atual (claro ou escuro).
    final colorScheme = Theme.of(context).colorScheme;
    // Estilos de letra do tema.
    final textTheme = Theme.of(context).textTheme;
    // Atalho: evita repetir task.isCompleted várias vezes.
    final isCompleted = task.isCompleted;

    // Card é o retângulo com sombra/elevação em volta do item.
    return Card(
      // margin é o espaço FORA do cartão (lados 16, cima/baixo 6).
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      // ListTile organiza: ícone à esquerda, texto no meio, botão à direita.
      child: ListTile(
        // leading fica à esquerda. Aqui é o checkbox.
        leading: Checkbox(
          // value mostra se a caixinha está marcada.
          value: isCompleted,
          // onChanged recebe o novo valor, mas usamos (_) e chamamos onToggle.
          // A Home é quem realmente inverte isCompleted.
          onChanged: (_) => onToggle(),
        ),
        // title é o texto principal do item.
        title: Text(
          // Mostra o nome da tarefa.
          task.title,
          style: textTheme.bodyLarge?.copyWith(
            // Se estiver concluída, riscamos o texto.
            // null = sem decoração (tarefa pendente).
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            // Operador ternário: se concluída, texto mais fraco; senão, normal.
            color: isCompleted
                ? colorScheme.onSurface.withValues(alpha: 0.45)
                : colorScheme.onSurface,
          ),
        ),
        // trailing fica à direita.
        trailing: IconButton(
          // tooltip aparece quando o mouse para em cima (útil no Windows).
          tooltip: 'Excluir tarefa',
          // Ícone de lixeira.
          icon: const Icon(Icons.delete_outline),
          // Ao tocar, avisa a Home para excluir.
          onPressed: onDelete,
        ),
      ),
    );
  }
}
