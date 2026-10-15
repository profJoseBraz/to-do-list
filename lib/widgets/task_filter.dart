// material.dart traz FilterChip, Row, Padding e Expanded.
import 'package:flutter/material.dart';

// TaskFilter mostra as três opções: Todas, Pendentes e Concluídas.
// StatelessWidget: ele não decide o filtro. Só mostra e avisa a Home.
class TaskFilter extends StatelessWidget {
  // Qual filtro está ativo agora: 'all', 'pending' ou 'completed'.
  final String selectedFilter;
  // Função que a Home passou. Recebe o novo valor quando o aluno toca.
  final ValueChanged<String> onChanged;

  const TaskFilter({
    super.key,
    required this.selectedFilter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Espaço em volta da fileira de chips.
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: [
          // Expanded divide a largura em 3 partes iguais.
          Expanded(child: _buildChip('all', 'Todas')),
          const SizedBox(width: 8),
          Expanded(child: _buildChip('pending', 'Pendentes')),
          const SizedBox(width: 8),
          Expanded(child: _buildChip('completed', 'Concluídas')),
        ],
      ),
    );
  }

  // Método auxiliar: monta um chip. value é o código, label é o texto da tela.
  Widget _buildChip(String value, String label) {
    // true se este chip é o filtro atualmente escolhido.
    final isSelected = selectedFilter == value;

    // FilterChip é o botãozinho que pode ficar selecionado.
    return FilterChip(
      selected: isSelected,
      // Center deixa o texto no meio do chip.
      label: Center(child: Text(label)),
      // showCheckmark: false esconde o ✓ extra; a cor já mostra a seleção.
      showCheckmark: false,
      // Ao tocar, avisamos a Home qual filtro foi escolhido.
      onSelected: (_) => onChanged(value),
    );
  }
}
