import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/cidade.dart';

class CidadeController {
  Future<Cidade?> getCidade(String cidadeId) async {
    final queryBuilder = QueryBuilder<Cidade>(Cidade())
      ..whereEqualTo('objectId', cidadeId);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.first as Cidade?;
    }

    log(response.error!.message);
    return null;
  }

  Future<List<Cidade>?> getAllCidades() async {
    final queryBuilder = QueryBuilder<Cidade>(Cidade());

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      log(response.results.toString());
      return response.results!.map((e) => e as Cidade).toList();
    }

    log(response.error!.message);
    return List<Cidade>.empty();
  }
}
