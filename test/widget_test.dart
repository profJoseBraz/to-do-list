import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_list/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('exibe a tela de login ao iniciar', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    expect(find.text('Minhas Tarefas'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
  });

  testWidgets('mostra erro com credenciais inválidas', (tester) async {
    await tester.pumpWidget(const TodoApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).at(0), 'aluno');
    await tester.enterText(find.byType(TextField).at(1), 'errada');
    await tester.tap(find.text('ENTRAR'));
    await tester.pump();

    expect(find.text('Usuário ou senha incorretos.'), findsOneWidget);
  });

  testWidgets('entra com aluno e 1234', (tester) async {
    await _login(tester);

    expect(find.text('Minhas tarefas'), findsOneWidget);
    expect(find.text('Hoje'), findsOneWidget);
  });

  testWidgets('adiciona uma nova tarefa depois do login', (tester) async {
    await _login(tester);

    await tester.enterText(find.byType(TextField), 'Estudar Flutter');
    await tester.tap(find.text('ADICIONAR'));
    await tester.pumpAndSettle();

    expect(find.text('Estudar Flutter'), findsOneWidget);
    expect(find.text('Você tem 1 tarefa pendente'), findsOneWidget);
  });

  testWidgets('não adiciona tarefa vazia', (tester) async {
    await _login(tester);

    await tester.tap(find.text('ADICIONAR'));
    await tester.pump();

    expect(find.text('Digite uma tarefa antes de adicionar.'), findsOneWidget);
  });
}

Future<void> _login(WidgetTester tester) async {
  await tester.pumpWidget(const TodoApp());
  await tester.pumpAndSettle();

  await tester.enterText(find.byType(TextField).at(0), 'aluno');
  await tester.enterText(find.byType(TextField).at(1), '1234');
  await tester.tap(find.text('ENTRAR'));
  await tester.pumpAndSettle();
}
