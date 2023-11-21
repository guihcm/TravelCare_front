import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/controllers/cidade_controller.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/finalidade.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/models/situacao.dart';
import 'package:travel_care/models/solicitacao.dart';
import 'package:travel_care/pages/init.dart';

class SolicitacaoController {
  final cidadeController = CidadeController();
  final pessoaController = PessoaController();

  Future<Solicitacao?> getSolicitacao(String solicitacaoId) async {
    final queryBuilder = QueryBuilder<Solicitacao>(Solicitacao())
      ..whereEqualTo('objectId', solicitacaoId);

    final response = await queryBuilder.query();

    if (response.success && response.results != null) {
      var solicitacao = response.results!.first as Solicitacao?;

      Cidade? cidade = await cidadeController
          .getCidade(solicitacao?["destinoId"]?["objectId"]);
      solicitacao?.destino = cidade;

      Pessoa? paciente = await pessoaController
          .getPessoa(solicitacao?["pacienteId"]?["objectId"]);
      solicitacao?.paciente = paciente;

      Pessoa? acompanhante = await pessoaController
          .getPessoa(solicitacao?["acompanhanteId"]?["objectId"]);
      solicitacao?.acompanhante = acompanhante ?? solicitacao.acompanhante;

      return solicitacao;
    }

    log(response.error!.message);
    return null;
  }

  Future<List<Solicitacao>?> getAllSolicitacoes() async {
    var user = await pessoaController.loggedUser();
    final queryBuilder = QueryBuilder<Solicitacao>(Solicitacao())
      ..whereEqualTo('pacienteId', user?.objectId)
      ..orderByDescending('createdAt');

    final response = await queryBuilder.query();

    List<Cidade>? cidades = await cidadeController.getAllCidades();

    if (response.success && response.results != null) {
      log(response.results.toString());
      return response.results!.map((e) {
        final s = e as Solicitacao;
        s.destino = cidades?.firstWhere(
            (element) => element.objectId == s["destinoId"]?["objectId"]);
        log(s.destino.toString());
        return s;
      }).toList();
    }

    log(response.error!.message);
    return List<Solicitacao>.empty();
  }

  void solicitar(
    BuildContext context,
    Cidade? cidade,
    DateTime? dataViagem,
    TextEditingController controllerEndereco,
    Finalidade? finalidade,
    DateTime? timeViagem,
    Pessoa? acompanhante,
  ) async {
    final solicitacao = Solicitacao();

    Pessoa? paciente = await pessoaController.loggedUser();
    paciente = Pessoa()..objectId = paciente?.objectId.toString();

    solicitacao.destino = cidade;
    solicitacao.finalidade = finalidade;
    solicitacao.horaEvento = timeViagem;
    solicitacao.dataViagem = dataViagem;
    solicitacao.endereco = controllerEndereco.text.trim();
    solicitacao.situacao = Situacao.pendente;
    solicitacao.paciente = paciente;

    var response = await solicitacao.save();

    if (!context.mounted) return;

    if (response.success) {
      log("Criação de solicitação realizada com sucesso!");

      if (acompanhante != null) {
        final result = await ParseCloudFunction('updateSolicitacaoAcompanhante')
            .execute(parameters: {
          'acompanhanteId': acompanhante.objectId,
          'solicitacaoId': solicitacao.objectId,
        });

        if (!context.mounted) return;

        if (result.success) {
          log("Adição de acompanhante na solicitação realizada com sucesso!");
        } else {
          log("Adição de acompanhante na solicitação falhou!");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return MyDialog("Algo deu errado. Tente novamente.",
                    () => Navigator.of(context).pop());
              });
        }
      }
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog(
                "Solicitaçao realizada com sucesso!",
                () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const InitPage())));
          });
    } else {
      log("Criação de solicitação falhou!");
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return MyDialog("Algo deu errado. Tente novamente.",
                () => Navigator.of(context).pop());
          });
    }
  }
}
