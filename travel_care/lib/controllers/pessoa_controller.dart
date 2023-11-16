import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/models/sexo.dart';
import 'package:travel_care/pages/home.dart';
import 'package:travel_care/pages/login.dart';

class PessoaController {
  
  Future<Pessoa?> loggedUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      return Pessoa.fromParseUser(user);
    }
    return null;
  }

  Future<bool> checkIsLogged() async {
    var currentUser = await loggedUser();
    if (currentUser != null) {
      return true;
    }
    return false;
  }

  void login(BuildContext context, TextEditingController controllerUsername,
      TextEditingController controllerPassword) async {
    final username = controllerUsername.text.trim();
    final password = controllerPassword.text.trim();

    final user = ParseUser(username, password, null);

    var response = await user.login();

    if (!context.mounted) return;

    if (response.success) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false);
    } else {
      String message = response.error!.message == "Invalid username/password."
          ? "Login ou senha incorretos."
          : "Algo deu errado. Tente novamente.";

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(message, () => Navigator.of(context).pop());
          });
    }
  }

  Future<void> logout(BuildContext context) async {
    final user = await ParseUser.currentUser() as ParseUser;
    var response = await user.logout(deleteLocalUserData: false);

    if (!context.mounted) return;

    if (response.success ||
        response.error!.message == "Invalid session token") {
      user.deleteLocalUserData();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog("Algo deu errado. Tente novamente.",
                () => Navigator.of(context).pop());
          });
    }
  }

  void salvarUsuario(
      BuildContext context,
      TextEditingController controllerPassword,
      TextEditingController controllerPasswordConfirmation,
      TextEditingController controllerUsername,
      TextEditingController controllerEmail,
      TextEditingController controllerNome,
      TextEditingController controllerCPF,
      TextEditingController controllerRG,
      TextEditingController controllerCNS,
      DateTime? dataNascimento,
      TextEditingController controllerTelefone,
      TextEditingController controllerEndereco,
      Sexo? sexo,
      Cidade? cidade) async {
    final password = controllerPassword.text.trim();
    final passwordConfirmation = controllerPasswordConfirmation.text.trim();

    if (password != passwordConfirmation) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "Senhas diferentes.", () => Navigator.of(context).pop());
          });
      return;
    }

    final username = controllerUsername.text.trim();
    final email = controllerEmail.text.trim();

    final pessoa =
        Pessoa(username: username, password: password, emailAddress: email);

    pessoa.nomeCompleto = controllerNome.text.trim();
    pessoa.cpf = controllerCPF.text.trim();
    pessoa.rg = controllerRG.text.trim();
    pessoa.cns = controllerCNS.text.trim();
    pessoa.dataNascimento = dataNascimento;
    pessoa.telefone = controllerTelefone.text.trim();
    pessoa.endereco = controllerEndereco.text.trim();
    pessoa.sexo = sexo;
    pessoa.cidade = cidade;

    var response = await pessoa.signUp();

    if (!context.mounted) return;

    if (response.success) {
      pessoa.deleteLocalUserData();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "Cadastro realizado com sucesso!",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage())));
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                response.error!.message ==
                        "Account already exists for this username."
                    ? "O login escolhido já existe."
                    : (response.error!.message ==
                            "Email address format is invalid."
                        ? "Formato inválido de e-mail."
                        : (response.error!.message ==
                                "Account already exists for this email address."
                            ? "O e-mail informado já existe."
                            : "Algo deu errado. Tente novamente.")),
                () => Navigator.of(context).pop());
          });
    }
  }

  void editarUsuario(
      BuildContext context,
      TextEditingController controllerUsername,
      TextEditingController controllerEmail,
      TextEditingController controllerNome,
      TextEditingController controllerCPF,
      TextEditingController controllerRG,
      TextEditingController controllerCNS,
      DateTime? dataNascimento,
      TextEditingController controllerTelefone,
      TextEditingController controllerEndereco,
      Sexo? sexo,
      Cidade? cidade) async {

    final pessoa = await loggedUser();

    pessoa!.username = controllerUsername.text.trim();
    pessoa.emailAddress = controllerEmail.text.trim();
    pessoa.nomeCompleto = controllerNome.text.trim();
    pessoa.cpf = controllerCPF.text.trim();
    pessoa.rg = controllerRG.text.trim();
    pessoa.cns = controllerCNS.text.trim();
    pessoa.dataNascimento = dataNascimento ?? pessoa.dataNascimento;
    pessoa.telefone = controllerTelefone.text.trim();
    pessoa.endereco = controllerEndereco.text.trim();
    pessoa.sexo = sexo ?? pessoa.sexo;
    pessoa.cidade = cidade;

    var response = await pessoa.save();

    if (!context.mounted) return;

    if (response.success) {
      pessoa.getUpdatedUser();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "Dados atualizados com sucesso!", () => Navigator.pop(context));
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                response.error!.message ==
                        "Account already exists for this username."
                    ? "O login escolhido já existe."
                    : (response.error!.message ==
                            "Email address format is invalid."
                        ? "Formato inválido de e-mail."
                        : (response.error!.message ==
                                "Account already exists for this email address."
                            ? "O e-mail informado já existe."
                            : "Algo deu errado. Tente novamente.")),
                () => Navigator.of(context).pop());
          });
    }
  }

  void recuperarSenha(
      BuildContext context, TextEditingController controllerEmail) async {

    var email = controllerEmail.text.trim();

    // consultar se email existe
    ParseUser user = ParseUser(null, null, email);
    var response = await user.requestPasswordReset();

    if (!context.mounted) {
      return;
    }

    if (response.success) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "E-mail enviado com sucesso.",
                () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginPage())));
          });
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog("Falha ao enviar email de redefinição de senha",
                () => Navigator.of(context).pop());
          });
    }
  }

  Future<Pessoa?> getPessoa(String? pessoaId) async{
    if(pessoaId == null) return null;

    final queryBuilder = QueryBuilder<Pessoa>(Pessoa())
      ..whereEqualTo('objectId', pessoaId);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.first as Pessoa?;
    }
    return null;
  }
}
