// AppSettings guarda preferências simples do aplicativo.
// Não é um sistema genérico de configurações: só o que a aula precisa.
class AppSettings {
  bool darkMode;
  bool confirmDelete;

  AppSettings({
    this.darkMode = false,
    this.confirmDelete = true,
  });
}
