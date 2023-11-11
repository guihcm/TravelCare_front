import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/estado.dart';

class Cidade extends ParseObject implements ParseCloneable {
  Cidade() : super('cidade');

  @override
  clone(Map<String, dynamic> map) => Cidade.clone()..fromJson(map);

  Cidade.clone() : this();

  static const String keyNome = 'nome';
  static const String keyEstadoId = 'estadoId';

  factory Cidade.fromParseObject(ParseObject object) {
    return Cidade()
      ..objectId = object.objectId
      ..nome = object[keyNome]
      ..estadoId = object[keyEstadoId];
  }

  String? get nome => get<String>(keyNome);
  set nome(String? nome) => set<String?>(keyNome, nome);

  Estado? get estadoId => get<Estado>(keyEstadoId);
  set estadoId(Estado? estadoId) => set<Estado?>(keyEstadoId, estadoId);

}
