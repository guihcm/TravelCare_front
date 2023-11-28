import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:travel_care/controllers/cidade_controller.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/controllers/solicitacao_controller.dart';
import 'package:travel_care/helpers/date_helper.dart';
import 'package:travel_care/helpers/validation_helper.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/finalidade.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/pages/request_next.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _acompanhanteKey = GlobalKey<ScaffoldState>();

  final controllerDataViagem = TextEditingController();
  final controllerHoraViagem = TextEditingController();

  Pessoa? p;

  final solicitacaoController = SolicitacaoController();

  late DateTime _dataViagem;
  late DateTime? _horaViagem;

  late Future<List<Cidade>?> cidadeList;

  final controllerEndereco = TextEditingController();
  final cidadeController = CidadeController();
  final pessoaController = PessoaController();

  Cidade? _cidade;
  Finalidade? _finalidade;

  String? acompanhanteId;

  Row ajax = Row();

  @override
  void initState() {
    super.initState();
    cidadeList = getCidades();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Cidade>?>(
        future: cidadeList,
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
              final cidades = snapshot.data;
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("Solicitar Viagem"),
                  ),
                  body: SingleChildScrollView(
                    child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                DropdownButtonFormField<Cidade>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  validator: (cidade) =>
                                      validateNotNull(cidade),
                                  decoration: const InputDecoration(
                                    labelText: "Cidade",
                                  ),
                                  hint: const Text("Selecione sua cidade"),
                                  onChanged: (Cidade? value) {
                                    setState(() {
                                      _cidade = value!;
                                    });
                                  },
                                  items: cidades!.map<DropdownMenuItem<Cidade>>(
                                      (Cidade value) {
                                    return DropdownMenuItem<Cidade>(
                                      value: value,
                                      child: Text(value.nome!),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 40),
                                TextFormField(
                                  controller: controllerDataViagem,
                                  keyboardType: TextInputType.none,
                                  decoration: const InputDecoration(
                                    hintText: 'Digite a data da viagem',
                                    labelText: "Data da viagem",
                                    suffixIcon: Icon(Icons.calendar_month),
                                  ),
                                  validator: (text) {
                                    return validateEmptyField(text);
                                  },
                                  onTap: () async {
                                    _dataViagem = await handleDate(
                                        context, controllerDataViagem, true);
                                  },
                                ),
                                const SizedBox(height: 40),
                                TextFormField(
                                  controller: controllerEndereco,
                                  decoration: const InputDecoration(
                                    hintText:
                                        'Ex: Avenida Aguas Claras, 65, Centro',
                                    labelText: "Endereço",
                                  ),
                                  validator: (text) {
                                    return validateEmptyField(text);
                                  },
                                ),
                                const SizedBox(height: 40),
                                DropdownButtonFormField<Finalidade>(
                                  icon: const Icon(Icons.arrow_drop_down),
                                  elevation: 16,
                                  decoration: const InputDecoration(
                                    labelText: "Finalidade",
                                  ),
                                  validator: (value) {
                                    return validateNotNull(value);
                                  },
                                  hint: const Text("Informe a finalidade."),
                                  onChanged: (Finalidade? value) {
                                    setState(() {
                                      _finalidade = value!;
                                    });
                                  },
                                  items: Finalidade.values
                                      .toList()
                                      .map<DropdownMenuItem<Finalidade>>(
                                          (Finalidade value) {
                                    return DropdownMenuItem<Finalidade>(
                                      value: value,
                                      child: Text(value.name.toLowerCase()),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(height: 40),
                                TextFormField(
                                  controller: controllerHoraViagem,
                                  readOnly: true,
                                  onTap: () async {
                                    _horaViagem = await selectTime(
                                        context, controllerHoraViagem);
                                  },
                                  decoration: const InputDecoration(
                                    labelText: 'Horário de Chegada:',
                                    hintText: 'Selecione o horário de chegada.',
                                    suffixIcon: Icon(Icons.access_time),
                                  ),
                                  validator: (text) {
                                    return validateEmptyField(text);
                                  },
                                ),
                                const SizedBox(height: 40),
                                ajax = Row(
                                  key: _acompanhanteKey,
                                  children: [
                                    Text('Possui um acompanhante? ',
                                        style: TextStyle(
                                          color: Colors.grey[700],
                                          fontSize: 18,
                                        )),
                                    const SizedBox(width: 3),
                                    GestureDetector(
                                      child: const Text(
                                        'Informe aqui.',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                        ),
                                      ),
                                      onTap: () => acompanhante(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 40),
                                ElevatedButton(
                                    child: const Text('Salvar',
                                        style: TextStyle(
                                          fontSize: 18,
                                        )),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        p = Pessoa()..objectId = acompanhanteId;

                                        solicitacaoController.solicitar(
                                          context,
                                          _cidade,
                                          _dataViagem,
                                          controllerEndereco,
                                          _finalidade,
                                          _horaViagem,
                                          p,
                                        );
                                      }
                                    }),
                              ],
                            ))),
                  ));
          }
        });
  }

  void reloadAcompanhante() {
    if (acompanhanteId != null) {
      setState(() {
        ajax = Row(
          key: _acompanhanteKey,
          children: [
            Text('deu certo ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 18,
                )),
            const SizedBox(width: 3),
            GestureDetector(
              child: const Text(
                'aeeeee.',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onTap: () => acompanhante(),
            ),
          ],
        );
      });
    }
  }

  Future<List<Cidade>?> getCidades() async {
    return await cidadeController.getAllCidades();
  }

  acompanhante() {
    final controllerCPF = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: AlertDialog(
            content: Column(
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
                    }),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fechar o diálogo
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
              TextButton(
                onPressed: () {
                  if (controllerCPF.text == "" ||
                      GetUtils.isCpf(controllerCPF.text) == false) {
                    Navigator.of(context).pop();
                    alert();
                  } else {
                    Navigator.of(context).pop();
                    next(controllerCPF.text);
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
        );
      },
    );
  }

  alert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const Text(
                'Digite um CPF válido',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Center(
                  child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  acompanhante();
                },
                child: const Text(
                  "Voltar",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  next(cpf) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return RequestNextDialog(cpf);
        }).then((value) {
      log("retorno: " + value.toString());
      acompanhanteId = value;
    }).then((value) => reloadAcompanhante());
  }
}
