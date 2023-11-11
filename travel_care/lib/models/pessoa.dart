import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/sexo.dart';

class Pessoa extends ParseUser implements ParseCloneable {
  Pessoa({String? username, String? password, String? emailAddress})
      : super(username, password, emailAddress);

  @override
  clone(Map<String, dynamic> map) => Pessoa.clone()..fromJson(map);

  Pessoa.clone() : this();

  static const String keyNomeCompleto = 'nomeCompleto';
  static const String keyCpf = 'CPF';
  static const String keyRg = 'RG';
  static const String keyCns = 'CNS';
  static const String keyDataNascimento = 'dataNascimento';
  static const String keyTelefone = 'telefone';
  static const String keySexo = 'sexo';
  static const String keyEndereco = 'endereco';
  static const String keyCidade = 'cidadeId';

  static Future<Pessoa?> loggedUser() async {
    final user = await ParseUser.currentUser() as ParseUser?;
    if (user != null) {
      return Pessoa.fromParseUser(user);
    }
    return null;
  }

  factory Pessoa.fromParseUser(ParseUser user) {
    return Pessoa()
      ..objectId = user.objectId
      ..username = user.username
      ..emailAddress = user.emailAddress
      ..nomeCompleto = user[keyNomeCompleto]
      ..cpf = user[keyCpf]
      ..rg = user[keyRg]
      ..cns = user[keyCns]
      ..dataNascimento = user[keyDataNascimento]
      ..telefone = user[keyTelefone]
      ..sexo = Sexo.values[user[keySexo]]
      ..endereco = user[keyEndereco]
      ..cidade = Cidade.fromParseObject(user[keyCidade]);
  }

  String? get nomeCompleto => get<String>(keyNomeCompleto);
  set nomeCompleto(String? nomeCompleto) =>
      set<String?>(keyNomeCompleto, nomeCompleto);

  String? get cpf => get<String>(keyCpf);
  set cpf(String? cpf) => set<String?>(keyCpf, cpf);

  String? get rg => get<String>(keyRg);
  set rg(String? rg) => set<String?>(keyRg, rg);

  String? get cns => get<String>(keyCns);
  set cns(String? cns) => set<String?>(keyCns, cns);

  DateTime? get dataNascimento => get<DateTime>(keyDataNascimento);
  set dataNascimento(DateTime? dataNascimento) =>
      set<DateTime?>(keyDataNascimento, dataNascimento);

  String? get telefone => get<String>(keyTelefone);
  set telefone(String? telefone) => set<String?>(keyTelefone, telefone);

  Sexo? get sexo {
    int? sexoIndex = get<int>(keySexo);
    if (sexoIndex == null) return null;
    return Sexo.values[sexoIndex];
  }
  set sexo(Sexo? sexo) => set<int?>(keySexo, sexo?.index);

  String? get endereco => get<String>(keyEndereco);
  set endereco(String? endereco) => set<String?>(keyEndereco, endereco);

  Cidade? get cidade => get<Cidade>(keyCidade);
  set cidade(Cidade? cidade) => set<Cidade?>(keyCidade, cidade);
}
