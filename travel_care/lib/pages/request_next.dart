import 'package:flutter/material.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/helpers/date_helper.dart';
import 'package:travel_care/helpers/string_helper.dart';
import 'package:travel_care/helpers/validation_helper.dart';
import 'package:travel_care/models/pessoa.dart';

class RequestNextDialog extends StatefulWidget {
  const RequestNextDialog(this.cpf, {super.key});

  final String cpf;

  @override
  State<StatefulWidget> createState() => _RequestNextDialogState();
}

class _RequestNextDialogState extends State<RequestNextDialog> {
  final pessoaController = PessoaController();
  late Future<Pessoa?> pessoaInit;

  final _formKey = GlobalKey<FormState>();

  final controllerNome = TextEditingController();
  final controllerCPF = TextEditingController();
  final controllerRG = TextEditingController();
  final controllerDataNascimento = TextEditingController();
  final controllerTelefone = TextEditingController();

  late String acompanhanteEscolhido = "";

  @override
  void initState() {
    super.initState();
    pessoaInit = person(widget.cpf);
  }

  DateTime? _dataNascimento;
  Future<Pessoa?> person(cpf) async {
    return await pessoaController.getAcompanhante(cpf);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: pessoaInit,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              );
            default:
              final pessoa = snapshot.data;
              var a = false;
              if (pessoa != null) {
                controllerNome.text = pessoa.nomeCompleto ?? "";
                controllerCPF.text = pessoa.cpf ?? "";
                controllerRG.text = pessoa.rg ?? "";
                controllerTelefone.text = pessoa.telefone ?? "";
                controllerDataNascimento.text =
                    formatDateString(pessoa.dataNascimento.toString()) ?? "";
                a = true;
              }

              return AlertDialog(
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        const Text(
                          'Informe seu Acompanhante',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          readOnly: a,
                          controller: controllerNome,
                          decoration: const InputDecoration(
                            hintText: 'Digite o completo',
                            labelText: "Nome Completo",
                          ),
                          validator: (text) {
                            return validateEmptyField(text);
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          readOnly: a,
                          controller: controllerCPF,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu CPF',
                            labelText: "CPF",
                          ),
                          validator: (text) {
                            return validateEmptyField(text);
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          readOnly: a,
                          controller: controllerRG,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu RG',
                            labelText: "RG",
                          ),
                          validator: (text) {
                            return validateEmptyField(text);
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          readOnly: a,
                          controller: controllerDataNascimento,
                          keyboardType: TextInputType.datetime,
                          decoration: const InputDecoration(
                            hintText: 'Digite sua data de nascimento',
                            labelText: "Data de nascimento",
                            suffixIcon: Icon(Icons.calendar_month),
                          ),
                          validator: (text) {
                            return validateEmptyField(text);
                          },
                          onTap: () async {
                            if (a == false) {
                              _dataNascimento = await handleDate(
                                  context, controllerDataNascimento);
                            }
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          readOnly: a,
                          controller: controllerTelefone,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu telefone',
                            labelText: "Telefone",
                          ),
                          validator: (text) {
                            return validateEmptyField(text);
                          },
                        ),
                        const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Fechar o diálogo
                                  },
                                  child: const Text(
                                    'Cancelar',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    if (a) {
                                      acompanhanteEscolhido = pessoa!.objectId!;
                                      Navigator.of(context).pop();
                                    } else {
                                      if (_formKey.currentState!.validate()) {
                                        pessoaController.salvarUsuario(
                                            context,
                                            null,
                                            null,
                                            null,
                                            null,
                                            controllerNome,
                                            controllerCPF,
                                            controllerRG,
                                            null,
                                            _dataNascimento,
                                            controllerTelefone,
                                            null,
                                            null,
                                            null);
                                      }
                                    }
                                  },
                                  child: const Text(
                                    'Confirmar',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
          }
        });
  }
}
