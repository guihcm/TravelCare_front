import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/estado.dart';

class Cidade extends ParseObject implements ParseCloneable {
  Cidade() : super('cidade');

  Cidade.clone() : this();

  @override
  clone(Map<String, dynamic> map) => Cidade.clone()..fromJson(map);

  static const String keyNome = 'nome';
  static const String keyEstadoId = 'estadoId';

  String? get nome => get<String>(keyNome);
  set nome(String? nome) => set<String?>(keyNome, nome);

  Estado? get estadoId => get<Estado>(keyEstadoId);
  set estadoId(Estado? estadoId) => set<Estado?>(keyEstadoId, estadoId);
}