import 'package:flutter/material.dart';
import 'package:travel_care/controllers/solicitacao_controller.dart';
import 'package:travel_care/helpers/string_helper.dart';
import 'package:travel_care/models/situacao.dart';
import 'package:travel_care/models/solicitacao.dart';

class RequestInfoDialog extends StatefulWidget {
  RequestInfoDialog(this.solicitacaoId, {super.key});

  String solicitacaoId;

  @override
  State<StatefulWidget> createState() => _RequestInfoDialogState();
}

class _RequestInfoDialogState extends State<RequestInfoDialog> {
  late Future<Solicitacao?> solicitacaoInit;
  final solicitaController = SolicitacaoController();

  Future<Solicitacao?> getSolicita(solicitacaoId) async {
    return await solicitaController.getSolicitacao(solicitacaoId);
  }

  @override
  void initState() {
    super.initState();
    solicitacaoInit = getSolicita(widget.solicitacaoId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Solicitacao?>(
      future: solicitacaoInit,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: SizedBox(
                  width: 100, height: 100, child: CircularProgressIndicator()),
            );
          default:
            final solicitacao = snapshot.data;
            //solicitacao?.horaEvento =
            //solicitacao.horaEvento?.subtract(Duration(hours: 3));
            return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  children: <Widget>[
                    Flex(
                      direction: Axis.vertical,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Paciente: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              solicitacao?.paciente?.nomeCompleto ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Acompanhante: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                solicitacao?.acompanhante?.nomeCompleto ??
                                    "Não",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Destino: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              solicitacao?.destino?.nome ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Data: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatDateString(
                                      solicitacao!.dataViagem.toString()) ??
                                  "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Finalidade: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              solicitacao.finalidade?.name ?? "",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Text(
                              'Horário de Chegada: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatHourString(
                                  solicitacao.horaEvento.toString()),
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                        const Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Situação: ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        switch (solicitacao.situacao!) {
                          Situacao.aceita => ClipRRect(
                              child: Image.asset(
                                'assets/images/aprovada.png',
                                height: 200,
                              ),
                            ),
                          Situacao.pendente => ClipRRect(
                              child: Image.asset(
                                'assets/images/analise.png',
                                height: 200,
                              ),
                            ),
                          Situacao.recusada => ClipRRect(
                              child: Image.asset(
                                'assets/images/recusada.png',
                                height: 200,
                              ),
                            ),
                        },
                        const SizedBox(height: 25),
                        Center(
                            child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "Voltar",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ))
                      ],
                    ),
                  ],
                ),
              ),
            );
        }
      },
    );
  }
}
