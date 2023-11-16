import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:travel_care/controllers/cidade_controller.dart';
import 'package:travel_care/controllers/pessoa_controller.dart';
import 'package:travel_care/models/cidade.dart';
import 'package:travel_care/models/pessoa.dart';
import 'package:travel_care/models/solicitacao.dart';

class SolicitacaoController {
  final cidadeController = CidadeController();
  final pessoaController = PessoaController();


  Future<Solicitacao?> getSolicitacao(String solicitacaoId) async {
    final queryBuilder = QueryBuilder<Solicitacao>(Solicitacao())
      ..whereEqualTo('objectId', solicitacaoId);

    final response = await queryBuilder.query();
    
    if (response.success && response.results != null) {
      var solicitacao = response.results!.first as Solicitacao?;
      
      Cidade? cidade = await cidadeController.getCidade(solicitacao?["destinoId"]?["objectId"]);
      solicitacao?.destino = cidade;
      
      Pessoa? paciente = await pessoaController.getPessoa(solicitacao?["pacienteId"]?["objectId"]);
      solicitacao?.paciente = paciente;
      
      Pessoa? acompanhante = await pessoaController.getPessoa(solicitacao?["acompanhanteId"]?["objectId"]);
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
      return response.results!.map((e){
        final s = e as Solicitacao;
        s.destino = cidades?.firstWhere((element) => element.objectId == s["destinoId"]?["objectId"]);
        log(s.destino.toString());
        return s;
      } ).toList();
    }

    log(response.error!.message);
    return List<Solicitacao>.empty();
  }
}
