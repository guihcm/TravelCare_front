import 'package:flutter/material.dart';
import 'package:travel_care/controllers/solicitacao_controller.dart';
import 'package:travel_care/helpers/string_helper.dart';
import 'package:travel_care/models/solicitacao.dart';
import 'package:travel_care/pages/request.dart';
import 'package:travel_care/pages/request_info.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});
  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  late Future<List<Solicitacao>?> solicitacaoList;

  final solicitacaoController = SolicitacaoController();

  @override
  void initState() {
    super.initState();
    solicitacaoList = getSolicitacoes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Solicitacao>?>(
        future: solicitacaoList,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator()),
              );
            default:
              final solicitacoes = snapshot.data;
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Column(children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Minhas Solicitações',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: solicitacoes!.isNotEmpty
                            ? ListView.builder(
                                itemCount: solicitacoes.length,
                                itemBuilder: (context, index) => Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
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
                                                  solicitacoes[index]
                                                          .destino
                                                          ?.nome ??
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
                                                  'Data: ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  formatDateString(
                                                          solicitacoes[index]
                                                              .dataViagem
                                                              .toString()) ??
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
                                                  'Situação: ',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  solicitacoes[index]
                                                          .situacao
                                                          ?.name ??
                                                      "",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () => info(
                                                      solicitacoes[index]
                                                          .objectId),
                                                  child: const Icon(
                                                    Icons.more_horiz,
                                                    color: Colors.blue,
                                                    size: 65.0,
                                                    semanticLabel: 'Saiba Mais',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                height: 25,
                                child: Text(
                                  "Você ainda não realizou uma solicitação de viagem.",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[300],
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20.0),
                          child: ElevatedButton(
                              onPressed: () => solicitar(),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ))),
                              child: const Text('Solicitar Viagem',
                                  style: TextStyle(
                                    fontSize: 22,
                                  ))),
                        ),
                      ],
                    ),
                  ]),
                ),
              );
          }
        });
  }

  info(solicitacaoId) {
    showDialog(
      context: context,
      builder: (BuildContext context) => RequestInfoDialog(solicitacaoId),
    );
  }

  void solicitar() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const RequestPage()));
  }

  Future<List<Solicitacao>?> getSolicitacoes() async {
    return await solicitacaoController.getAllSolicitacoes();
  }
}
