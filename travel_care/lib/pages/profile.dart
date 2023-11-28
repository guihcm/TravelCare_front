import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:travel_care/controllers/cidade_controller.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/helpers/date_helper.dart';
import 'package:travel_care/helpers/string_helper.dart';
import 'package:travel_care/helpers/validation_helper.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/models/sexo.dart';
import 'package:travel_care/page_models/profile_model.dart';
import 'package:travel_care/pages/password.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final controllerNome = TextEditingController();
  final controllerCPF = TextEditingController();
  final controllerRG = TextEditingController();
  final controllerCNS = TextEditingController();
  final controllerDataNascimento = TextEditingController();
  final controllerTelefone = TextEditingController();
  final controllerEndereco = TextEditingController();
  final controllerPassword = TextEditingController();
  final controllerPasswordConfirmation = TextEditingController();
  final controllerEmail = TextEditingController();

  DateTime? _dataNascimento;

  late Future<ProfileModel> profileModel;

  final cidadeController = CidadeController();
  final pessoaController = PessoaController();

  Cidade? _cidade;

  Sexo? _sexo;

  @override
  void initState() {
    super.initState();
    profileModel = loadProfileModel();
    setCidade(profileModel);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProfileModel>(
        future: profileModel,
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
              final pessoa = snapshot.data?.pessoa;
              final cidades = snapshot.data?.cidades;

              controllerNome.text = pessoa!.nomeCompleto ?? "";
              controllerCPF.text = pessoa.cpf ?? "";
              controllerRG.text = pessoa.rg ?? "";
              controllerCNS.text = pessoa.cns ?? "";
              if(pessoa.dataNascimento != null){
                controllerDataNascimento.text = 
                   formatDateString(pessoa.dataNascimento.toString());
              }
              controllerTelefone.text = pessoa.telefone ?? "";
              controllerEndereco.text = pessoa.endereco ?? "";
              controllerEmail.text = pessoa.emailAddress ?? "";

              return Scaffold(
                  body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: controllerNome,
                              decoration: const InputDecoration(
                                hintText: 'Digite seu nome completo',
                                labelText: "Nome Completo",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            ),
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
                                if(validateEmptyField(text) == null){
                                  if(GetUtils.isCpf(controllerCPF.text)){
                                    return validateEmptyField(text);
                                  }
                                  else{
                                    return "* CPF Inválido";
                                  }
                                }
                                else{
                                  return validateEmptyField(text);
                                }
                              },
                            ),
                            TextFormField(
                              controller: controllerRG,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                hintText: 'Digite seu RG',
                                labelText: "RG",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            ),
                            TextFormField(
                              controller: controllerCNS,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: 'Digite seu CNS',
                                labelText: "CNS",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            ),
                            TextFormField(
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
                                _dataNascimento = await handleDate(
                                    context, controllerDataNascimento, false);
                              },
                            ),
                            TextFormField(
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
                            DropdownButtonFormField<Sexo>(
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              validator: (sexo) => validateNotNull(sexo),
                              decoration: const InputDecoration(
                                labelText: "Sexo",
                              ),
                              hint: const Text("Selecione seu sexo"),
                              onChanged: (Sexo? value) {
                                _sexo = value!;
                              },
                              value: pessoa.sexo,
                              items: Sexo.values
                                  .toList()
                                  .map<DropdownMenuItem<Sexo>>((Sexo value) {
                                return DropdownMenuItem<Sexo>(
                                  value: value,
                                  child: Text(value.name.toLowerCase()),
                                );
                              }).toList(),
                            ),
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
                            DropdownButtonFormField<Cidade>(
                              icon: const Icon(Icons.arrow_drop_down),
                              elevation: 16,
                              validator: (cidade) => validateNotNull(cidade),
                              decoration: const InputDecoration(
                                labelText: "Cidade",
                              ),
                              hint: const Text("Selecione sua cidade"),
                              onChanged: (Cidade? value) {
                                  _cidade = value!;
                              },
                              value: _cidade,
                              items: cidades!.map<DropdownMenuItem<Cidade>>(
                                  (Cidade value) {
                                return DropdownMenuItem<Cidade>(
                                  value: value,
                                  child: Text(value.nome!),
                                );
                              }).toList(),
                            ),
                            TextFormField(
                              controller: controllerEmail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                hintText: 'Ex: seuemail@email.com',
                                labelText: "E-mail",
                              ),
                              validator: (text) {
                                return validateEmptyField(text);
                              },
                            ),
                            const SizedBox(height: 15),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                GestureDetector(
                                  child: const Text(
                                    'Redefinir senha',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PasswordPage(pessoa.emailAddress))),                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                                child: const Text('Salvar',
                                    style: TextStyle(
                                      fontSize: 18,
                                    )),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    pessoaController.editarUsuario(
                                        context,
                                        controllerEmail,
                                        controllerNome,
                                        controllerCPF,
                                        controllerRG,
                                        controllerCNS,
                                        _dataNascimento,
                                        controllerTelefone,
                                        controllerEndereco,
                                        _sexo,
                                        _cidade);
                                  }
                                }),
                          ],
                        ))),
              ));
          }
        });
  }

  Future<ProfileModel> loadProfileModel() async {
    final cidades = await cidadeController.getAllCidades();
    final pessoa = await pessoaController.loggedUser();

    return ProfileModel(pessoa, cidades);
  }

  Future<void> setCidade(Future<ProfileModel> model) async {
    ProfileModel profileModel = await model;

    Pessoa? pessoa = profileModel.pessoa;
    List<Cidade>? cidades = profileModel.cidades;

    _cidade = pessoa?.cidade?.objectId != null
        ? cidades?.firstWhere(
            (element) => element.objectId == pessoa?.cidade?.objectId)
        : null;
  }
}
