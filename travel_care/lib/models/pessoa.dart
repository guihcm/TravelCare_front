import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/cidade.dart';

class Pessoa extends ParseUser implements ParseCloneable {

  Pessoa({String? username, String? password, String? emailAddress})
      : super(username, password, emailAddress);

  @override
  clone(Map<String, dynamic> map) => Pessoa.clone()..fromJson(map);

  Pessoa.clone(): this();

  static const String keyNomeCompleto = 'nomeCompleto';
  static const String keyCpf = 'CPF';
  static const String keyRg = 'RG';
  static const String keyDataNascimento = 'dataNascimento';
  static const String keyEndereco = 'endereco';
  static const String keyCidade = 'cidadeId';


  String? get nomeCompleto => get<String>(keyNomeCompleto);
  set nomeCompleto(String? nomeCompleto) => set<String?>(keyNomeCompleto, nomeCompleto);

  String? get cpf => get<String>(keyCpf);
  set cpf(String? cpf) => set<String?>(keyCpf, cpf);

  String? get rg => get<String>(keyRg);
  set rg(String? rg) => set<String?>(keyRg, rg);

  DateTime? get dataNascimento => get<DateTime>(keyDataNascimento);
  set dataNascimento(DateTime? dataNascimento) => set<DateTime?>(keyDataNascimento, dataNascimento);

  String? get endereco => get<String>(keyEndereco);
  set endereco(String? endereco) => set<String?>(keyEndereco, endereco);

  Cidade? get cidade => get<Cidade>(keyCidade);
  set cidade(Cidade? cidade) => set<Cidade?>(keyCidade, cidade);
  
}