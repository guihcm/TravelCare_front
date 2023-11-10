import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/models/solicitacao.dart';

class SolicitacaoController {
  Future<Solicitacao?> getSolicitacao(String solicitacaoId) async {
    final queryBuilder = QueryBuilder<Solicitacao>(Solicitacao())
      ..whereEqualTo('objectId', solicitacaoId);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      return response.results!.first as Solicitacao?;
    }

    log(response.error!.message);
    return null;
  }

  Future<List<Solicitacao>?> getAllSolicitacoes() async {
    final queryBuilder = QueryBuilder<Solicitacao>(Solicitacao());

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      log(response.results.toString());
      return response.results!.map((e) => e as Solicitacao).toList();
    }

    log(response.error!.message);
    return null;
  }
}
