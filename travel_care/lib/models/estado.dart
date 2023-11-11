import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class Estado extends ParseObject implements ParseCloneable {
  Estado() : super('estado');

  @override
  clone(Map<String, dynamic> map) => Estado.clone()..fromJson(map);

  Estado.clone() : this();

  static const String keyNome = 'nome';
  static const String keyUf = 'UF';

    factory Estado.fromParseObject(ParseObject object) {
    return Estado()
      ..objectId = object.objectId
      ..nome = object[keyNome]
      ..uf = object[keyUf];
  }

  String? get nome => get<String>(keyNome);
  set nome(String? nome) => set<String?>(keyNome, nome);

  String? get uf => get<String>(keyUf);
  set uf(String? uf) => set<String?>(keyUf, uf);
}