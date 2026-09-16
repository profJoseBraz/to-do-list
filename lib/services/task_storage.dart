import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

// TaskStorage cuida APENAS de salvar e carregar as tarefas.
// A tela (HomePage) não precisa saber como o celular guarda os dados.
//
// Fluxo:
// HomePage -> TaskStorage -> SharedPreferences -> armazenamento do celular
class TaskStorage {
  // Nome da "gaveta" onde as tarefas ficam guardadas no celular.
  static const String _storageKey = 'tasks';

  // Future significa: "o resultado vai chegar depois".
  // async/await permite esperar essa resposta sem travar a tela.
  Future<List<Task>> loadTasks() async {
    // SharedPreferences é um armazenamento local simples.
    // Os dados ficam no celular e funcionam sem internet.
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);

    // Se ainda não existir nada salvo, devolvemos uma lista vazia.
    if (jsonString == null) {
      return [];
    }

    // jsonDecode transforma o texto JSON em uma lista de Maps.
    final List<dynamic> decodedList = jsonDecode(jsonString);

    // Cada Map vira novamente um objeto Task.
    return decodedList
        .map((item) => Task.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();

    // Primeiro cada Task vira Map, depois a lista inteira vira texto JSON.
    final jsonString = jsonEncode(
      tasks.map((task) => task.toJson()).toList(),
    );

    await prefs.setString(_storageKey, jsonString);
  }
}
