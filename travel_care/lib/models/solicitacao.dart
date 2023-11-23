import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/finalidade.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/models/situacao.dart';

class Solicitacao extends ParseObject {
  Solicitacao() : super('solicitacao');

  @override
  clone(Map<String, dynamic> map) => Solicitacao.clone()..fromJson(map);

  Solicitacao.clone() : this();

  static const String keyFinalidade = 'finalidade';
  static const String keySituacao = 'situacao';
  static const String keyDataViagem = 'dataViagem';
  static const String keyHoraEvento = 'horaEvento';
  static const String keyDestinoId = 'destinoId';
  static const String keyPacienteId = 'pacienteId';
  static const String keyAcompanhanteId = 'acompanhanteId';
  static const String keyEndereco = 'endereco';


  factory Solicitacao.fromParseObject(ParseObject? object) {
    return Solicitacao()
      ..objectId = object?.objectId
      ..finalidade = object?[keyFinalidade] != null
          ? Finalidade.values[object?[keyFinalidade]]
          : null
      ..situacao = object?[keySituacao] != null
          ? Situacao.values[object?[keySituacao]]
          : null
      ..dataViagem = object?[keyDataViagem]
      ..horaEvento = object?[keyHoraEvento]
      ..destino = Cidade.fromParseObject(object?[keyDestinoId])
      ..paciente = Pessoa.fromParseUser(object?[keyPacienteId])
      ..acompanhante = Pessoa.fromParseUser(object?[keyAcompanhanteId])
      ..endereco = object?[keyEndereco];
  }

  Finalidade? get finalidade {
    int? finalidadeIndex = get<int>(keyFinalidade);
    if (finalidadeIndex == null) return null;
    return Finalidade.values[finalidadeIndex];
  }
  set finalidade(Finalidade? finalidade) => set<int?>(keyFinalidade, finalidade?.index);


  Situacao? get situacao {
    int? situacaoIndex = get<int>(keySituacao);
    if (situacaoIndex == null) return null;
    return Situacao.values[situacaoIndex];
  }
  set situacao(Situacao? situacao) => set<int?>(keySituacao, situacao?.index);

  DateTime? get dataViagem => get<DateTime>(keyDataViagem);
  set dataViagem(DateTime? dataViagem) =>
      set<DateTime?>(keyDataViagem, dataViagem);

  DateTime? get horaEvento => get<DateTime>(keyHoraEvento);
  set horaEvento(DateTime? horaEvento) =>
      set<DateTime?>(keyHoraEvento, horaEvento);

  Cidade? get destino => get<Cidade>(keyDestinoId);
  set destino(Cidade? destinoId) =>
      set<Cidade?>(keyDestinoId, destinoId);

  Pessoa? get paciente => get<Pessoa>(keyPacienteId);
  set paciente(Pessoa? pacienteId) =>
      set<Pessoa?>(keyPacienteId, pacienteId);

  Pessoa? get acompanhante => get<Pessoa>(keyAcompanhanteId);
  set acompanhante(Pessoa? acompanhanteId) =>
      set<Pessoa?>(keyAcompanhanteId, acompanhanteId);

  String? get endereco => get<String>(keyEndereco);
  set endereco(String? endereco) => set<String?>(keyEndereco, endereco);
}
