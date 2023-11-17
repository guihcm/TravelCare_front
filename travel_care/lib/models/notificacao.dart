import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/models/solicitacao.dart';

class Notificacao extends ParseObject implements ParseCloneable {
  Notificacao() : super('notificacao');

  @override
  clone(Map<String, dynamic> map) => Notificacao.clone()..fromJson(map);

  Notificacao.clone() : this();

  static const String keyTexto = 'texto';
  static const String keyVisto = 'visto';
  static const String keySolicitacaoId = 'solicitacaoId';
  static const String keyPacienteId = 'pacienteId';

  String? get texto => get<String>(keyTexto);
  set texto(String? texto) => set<String?>(keyTexto, texto);

  bool? get visto => get<bool>(keyVisto);
  set visto(bool? visto) => set<bool?>(keyVisto, visto);

  Solicitacao? get solicitacao => get<Solicitacao>(keySolicitacaoId);
  set solicitacao(Solicitacao? solicitacaoId) => set<Solicitacao?>(keySolicitacaoId, solicitacaoId);

  Pessoa? get paciente => get<Pessoa>(keyPacienteId);
  set paciente(Pessoa? pacienteId) => set<Pessoa?>(keyPacienteId, pacienteId);
}
