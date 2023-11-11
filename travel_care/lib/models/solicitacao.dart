import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/cidade.dart';
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

  factory Solicitacao.fromParseObject(ParseObject object) {
    return Solicitacao()
      ..objectId = object.objectId
      ..finalidade = object[keyFinalidade]
      ..situacao = Situacao.values[object[keySituacao]]
      ..dataViagem = object[keyDataViagem]
      ..horaEvento = object[keyHoraEvento]
      ..destino = Cidade.fromParseObject(object[keyDestinoId])
      ..paciente = Pessoa.fromParseUser(object[keyPacienteId])
      ..acompanhante = Pessoa.fromParseUser(object[keyAcompanhanteId]);
  }

  String? get finalidade => get<String>(keyFinalidade);
  set finalidade(String? finalidade) => set<String?>(keyFinalidade, finalidade);

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

  ParseObject? get destino => get<ParseObject>(keyDestinoId);
  set destino(ParseObject? destinoId) =>
      set<ParseObject?>(keyDestinoId, destinoId);

  ParseObject? get paciente => get<ParseObject>(keyPacienteId);
  set paciente(ParseObject? pacienteId) =>
      set<ParseObject?>(keyPacienteId, pacienteId);

  ParseObject? get acompanhante => get<ParseObject>(keyAcompanhanteId);
  set acompanhante(ParseObject? acompanhanteId) =>
      set<ParseObject?>(keyAcompanhanteId, acompanhanteId);
}
