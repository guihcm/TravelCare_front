import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
              var readOnly = false;
              if (pessoa != null) {
                controllerNome.text = pessoa.nomeCompleto ?? "";
                controllerCPF.text = pessoa.cpf ?? "";
                controllerRG.text = pessoa.rg ?? "";
                controllerTelefone.text = pessoa.telefone ?? "";
                controllerDataNascimento.text =
                    formatDateString(pessoa.dataNascimento.toString()) ?? "";
                readOnly = true;
              } else {
                controllerCPF.text = widget.cpf;
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
                          readOnly: readOnly,
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
                          readOnly: readOnly,
                          controller: controllerCPF,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu CPF',
                            labelText: "CPF",
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfInputFormatter()
                          ],
                          validator: (text) {
                            return validateEmptyField(text);
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          readOnly: readOnly,
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
                          readOnly: readOnly,
                          controller: controllerDataNascimento,
                          keyboardType: TextInputType.none,
                          decoration: const InputDecoration(
                            hintText: 'Digite sua data de nascimento',
                            labelText: "Data de nascimento",
                            suffixIcon: Icon(Icons.calendar_month),
                          ),
                          validator: (text) {
                            return validateEmptyField(text);
                          },
                          onTap: () async {
                            if (readOnly == false) {
                              _dataNascimento = await handleDate(
                                  context, controllerDataNascimento, false);
                            }
                          },
                        ),
                        const SizedBox(height: 40),
                        TextFormField(
                          readOnly: readOnly,
                          controller: controllerTelefone,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Digite seu telefone',
                            labelText: "Telefone",
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter()
                          ],
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
                                    if (readOnly) {
                                      acompanhanteEscolhido = pessoa!.objectId!;
                                      Navigator.of(context)
                                          .pop(acompanhanteEscolhido);
                                    } else {
                                      if (_formKey.currentState!.validate()) {
                                        pessoaController.salvarAcompanhante(
                                          context,
                                          controllerNome,
                                          controllerCPF,
                                          controllerRG,
                                          _dataNascimento,
                                          controllerTelefone,
                                        );
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
