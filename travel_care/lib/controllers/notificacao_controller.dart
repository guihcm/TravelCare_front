import 'dart:developer';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/models/notificacao.dart';
import 'package:travel_care/models/solicitacao.dart';

class NotificacaoController {
  final pessoaController = PessoaController();

  Future<List<Notificacao>?> getAllNotificacoes() async {
    var user = await pessoaController.loggedUser();
    final queryBuilder = QueryBuilder<Notificacao>(Notificacao())
      ..whereEqualTo('pacienteId', user?.objectId)
      ..orderByDescending('createdAt');

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      log(response.results.toString());
      return response.results!.map((e) {
        final notificacao = e as Notificacao;
        notificacao.solicitacao = Solicitacao()
          ..objectId = notificacao["solicitacaoId"]!["objectId"];
        return notificacao;
      }).toList();
    }

    log(response.error!.message);
    return List<Notificacao>.empty();
  }

  Future<void> editarNotificacao(Notificacao notificacao) async {
    notificacao.save();
  }
}
