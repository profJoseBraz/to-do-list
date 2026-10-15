// Uma CLASSE é um molde. Ela descreve quais dados um objeto pode ter.
// Cada tarefa da lista será um OBJETO criado a partir deste molde Task.
class Task {
  // final String id: texto que não muda depois de criado.
  // O id identifica cada tarefa. Sem ele, não saberíamos qual excluir.
  final String id;

  // title é o texto que o aluno vê na lista, por exemplo "Estudar Flutter".
  final String title;

  // bool só pode ser true ou false.
  // Não é final porque o aluno pode marcar e desmarcar a tarefa.
  // true  = concluída
  // false = ainda pendente
  bool isCompleted;

  // DateTime guarda ano, mês e dia (e também hora, se precisar).
  // Aqui usamos para saber a qual dia a tarefa pertence.
  final DateTime date;

  // O CONSTRUTOR é chamado na hora de criar: Task(id: ..., title: ..., date: ...).
  Task({
    // required obriga quem cria a tarefa a informar o id.
    required this.id,
    // required também para o título.
    required this.title,
    // required para a data do dia da tarefa.
    required this.date,
    // Se ninguém passar isCompleted, o padrão é false (pendente).
    this.isCompleted = false,
  });

  // toJson transforma este objeto em um Map (chave e valor).
  // JSON é texto. SharedPreferences não entende objeto Dart, só texto.
  Map<String, dynamic> toJson() {
    // return devolve o mapa que será gravado.
    return {
      // A chave 'id' guarda o identificador.
      'id': id,
      // A chave 'title' guarda o texto da tarefa.
      'title': title,
      // A chave 'isCompleted' guarda se está concluída.
      'isCompleted': isCompleted,
      // DateTime precisa virar texto para entrar no JSON.
      // toIso8601String() gera um formato padrão, por exemplo:
      // 2026-09-08T00:00:00.000
      'date': date.toIso8601String(),
    };
  }

  // factory é um construtor especial: em vez de só criar, ele pode
  // montar o objeto a partir de dados que já existem (o JSON).
  factory Task.fromJson(Map<String, dynamic> json) {
    // Recria a Task lendo cada chave do mapa.
    return Task(
      // as String avisa o Dart: "tenho certeza de que isto é texto".
      id: json['id'] as String,
      title: json['title'] as String,
      isCompleted: json['isCompleted'] as bool,
      // Tarefas antigas podem não ter a chave 'date'.
      // Se json['date'] não for nulo, convertemos o texto em DateTime.
      // Se for nulo, usamos o dia de hoje para o app não quebrar.
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
    );
  }
}

// Função solta (não pertence à classe). Compara só o dia, sem hora.
// Exemplo: 08/09/2026 10:00 e 08/09/2026 22:00 são o mesmo dia.
bool isSameDay(DateTime a, DateTime b) {
  // && significa E: os três pedaços precisam ser verdadeiros.
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

// Transforma a data no formato brasileiro: 08/09/2026.
String formatShortDate(DateTime date) {
  // padLeft(2, '0') coloca zero à esquerda: 8 vira "08".
  final day = date.day.toString().padLeft(2, '0');
  // O mesmo para o mês: 9 vira "09".
  final month = date.month.toString().padLeft(2, '0');
  // $ coloca as variáveis dentro do texto.
  return '$day/$month/${date.year}';
}

// Joga fora hora e minuto. Fica só ano, mês e dia (meia-noite).
// Assim duas tarefas do mesmo dia ficam fáceis de comparar.
DateTime dateOnly(DateTime date) {
  return DateTime(date.year, date.month, date.day);
}
