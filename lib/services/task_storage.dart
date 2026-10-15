// dart:convert traz jsonEncode e jsonDecode.
// Eles transformam objeto ↔ texto JSON.
import 'dart:convert';

// shared_preferences é o pacote que grava dados simples no aparelho.
import 'package:shared_preferences/shared_preferences.dart';

// Precisamos da classe Task para salvar e recarregar a lista.
import '../models/task.dart';

// TaskStorage cuida APENAS de salvar e carregar as tarefas.
// A HomePage não precisa saber COMO o aparelho guarda os dados.
//
// Fluxo:
// HomePage -> TaskStorage -> SharedPreferences -> disco do Windows/celular
class TaskStorage {
  // static const: valor fixo da classe, igual para todos os objetos.
  // 'tasks' é o nome da "gaveta" onde a lista fica guardada.
  static const String _storageKey = 'tasks';

  // Future<List<Task>> = "mais tarde vou devolver uma lista de tarefas".
  // async/await espera o disco sem travar a tela.
  Future<List<Task>> loadTasks() async {
    // getInstance() pede ao sistema o acesso ao armazenamento local.
    final prefs = await SharedPreferences.getInstance();
    // getString lê o texto JSON salvo na gaveta 'tasks'.
    // Se nunca salvamos nada, o resultado é null.
    final jsonString = prefs.getString(_storageKey);

    // null significa: primeira execução, ainda não há tarefas.
    if (jsonString == null) {
      // Lista vazia: [] .
      return [];
    }

    // jsonDecode transforma o texto em uma lista de mapas.
    // dynamic = o Dart ainda não sabe o tipo de cada item.
    final List<dynamic> decodedList = jsonDecode(jsonString);

    // map percorre cada item e transforma em Task com fromJson.
    // as Map<String, dynamic> avisa o tipo de cada elemento.
    // toList() junta o resultado em uma List<Task>.
    return decodedList
        .map((item) => Task.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // void = não devolve valor. Só grava a lista.
  Future<void> saveTasks(List<Task> tasks) async {
    // Abre de novo o armazenamento local.
    final prefs = await SharedPreferences.getInstance();

    // Cada Task vira Map (toJson). A lista de Maps vira texto (jsonEncode).
    final jsonString = jsonEncode(
      tasks.map((task) => task.toJson()).toList(),
    );

    // setString grava o texto na gaveta 'tasks', substituindo o valor antigo.
    await prefs.setString(_storageKey, jsonString);
  }
}
