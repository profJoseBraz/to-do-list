// AppSettings é um molde pequeno para as preferências do aplicativo.
// Não é um sistema genérico: só o que a aula precisa.
class AppSettings {
  // darkMode = true  → tema escuro
  // darkMode = false → tema claro
  bool darkMode;

  // confirmDelete = true  → pergunta antes de apagar a tarefa
  // confirmDelete = false → apaga na hora
  bool confirmDelete;

  // Construtor. Se ninguém passar valores, usamos estes padrões.
  AppSettings({
    // Por padrão o app abre no modo claro.
    this.darkMode = false,
    // Por padrão pedimos confirmação para excluir. É mais seguro para o aluno.
    this.confirmDelete = true,
  });
}
