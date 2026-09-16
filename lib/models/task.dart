// Uma CLASSE é um molde. Ela descreve quais dados um objeto pode ter
// e o que ele representa. Cada tarefa da lista será um OBJETO Task.
class Task {
  // O id identifica cada tarefa de forma única.
  // Sem ele, ficaria difícil saber qual item excluir ou marcar como concluído.
  final String id;

  // Título visível para o aluno na tela.
  final String title;

  // isCompleted guarda se a tarefa já foi feita.
  // true  = concluída
  // false = ainda pendente
  bool isCompleted;

  // date indica o dia da tarefa. DateTime guarda ano, mês e dia.
  final DateTime date;

  // O CONSTRUTOR recebe os valores na hora de criar a tarefa.
  Task({
    required this.id,
    required this.title,
    required this.date,
    this.isCompleted = false,
  });

  // JSON é um formato de texto usado para guardar dados.
  // SharedPreferences não entende objetos Dart, então convertemos
  // a Task para um Map (chave e valor) e depois para JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      // DateTime precisa virar texto para entrar no JSON.
      // toIso8601String() gera um formato padrão, por exemplo:
      // 2026-09-08T00:00:00.000
      'date': date.toIso8601String(),
    };
  }

  // fromJson faz o caminho inverso:
  // lê o JSON e recria um objeto Task na memória.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      // Tarefas antigas podem não ter data.
      // Nesse caso usamos o dia de hoje para o aplicativo não quebrar.
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
    );
  }
}

// Compara só o dia, ignorando hora e minuto.
bool isSameDay(DateTime a, DateTime b) {
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

// Mostra a data no formato brasileiro: 08/09/2026
String formatShortDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

DateTime dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
