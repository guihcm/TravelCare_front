import 'package:flutter/material.dart';
import 'package:travel_care/controllers/cidade_controller.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/helpers/date_helper.dart';
import 'package:travel_care/helpers/validation_helper.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/finalidade.dart';
import 'package:travel_care/models/sexo.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  final _formKey = GlobalKey<FormState>();

  final controllerDataViagem = TextEditingController();
  final controllerHoraViagem = TextEditingController();


final TextEditingController _timeController = TextEditingController();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      _timeController.text = picked.format(context);
    }
  }





  late DateTime _dataViagem;
  late TimeOfDay _horaViagem;

  late Future<List<Cidade>?> cidadeList;

  final controllerEndereco = TextEditingController();
  final cidadeController = CidadeController();
  final pessoaController = PessoaController();

  Cidade? _cidade;
  Finalidade? _finalidade;
  

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
                                  items: cidades!
                                      .map<DropdownMenuItem<Cidade>>(
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
                                  keyboardType: TextInputType.datetime,
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
                                        context, controllerDataViagem);
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
                                  controller: _timeController,
                                  readOnly: true,
                                  onTap: () => _selectTime(context),
                                  decoration: const InputDecoration(
                                    labelText: 'Horário de Chegada:',
                                    hintText: 'Selecione o horário de chegada.',
                                    suffixIcon: Icon(Icons.access_time),
                                  ),
                                ),

                                const SizedBox(height: 40),

                                ElevatedButton(
                                    child: const Text('Salvar',
                                        style: TextStyle(
                                          fontSize: 18,
                                        )),
                                    onPressed: () {
                                      //if (_formKey.currentState!.validate()) {
                                        //pessoaController.salvarUsuario(
                                            //context, _cidade);
                                      //}
                                    }),
                              ],
                            ))),
                  ));
          }
        });
  }

  Future<List<Cidade>?> getCidades() async {
    return await cidadeController.getAllCidades();
  }

  
}
