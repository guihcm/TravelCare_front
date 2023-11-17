import 'package:flutter/material.dart';
import 'package:travel_care/controllers/notificacao_controller.dart';
import 'package:travel_care/models/notificacao.dart';
import 'package:travel_care/pages/request_info.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late Future<List<Notificacao>?> futureNotificacoes;
  final notificacaoController = NotificacaoController();

  @override
  void initState() {
    super.initState();
    futureNotificacoes = getNotificacoes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Notificacao>?>(
        future: futureNotificacoes,
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
              final notificacoes = snapshot.data;
              return Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Notificações',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: notificacoes!.isNotEmpty 
                        ? ListView.builder(
                            itemCount: notificacoes.length,
                            itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(bottom: 2),
                                  child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.white10,
                                        child: notificacoes[index].visto!
                                            ? const Icon(
                                                Icons.notifications_none)
                                            : const Icon(
                                                Icons.notifications_active),
                                      ),
                                      tileColor: notificacoes[index].visto!
                                          ? Colors.white
                                          : Colors.grey[200],
                                      title: notificacoes[index].visto!
                                          ? Text(notificacoes[index].texto!)
                                          : Text(
                                              notificacoes[index].texto!,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                      trailing: PopupMenuButton<String>(
                                        itemBuilder: (BuildContext context) {
                                          return {'Marcar como visto'}
                                              .map((String choice) {
                                            return PopupMenuItem<String>(
                                              value: choice,
                                              child: Text(
                                                choice,
                                                style: const TextStyle(
                                                    color: Colors.white),
                                              ),
                                            );
                                          }).toList();
                                        },
                                        onSelected: (String choice) {
                                          if (choice == 'Marcar como visto') {
                                            marcarComoVisto(
                                                notificacoes[index]);
                                          }
                                        },
                                        color: Colors.blue,
                                      ),
                                      onTap: () {
                                      marcarComoVisto(notificacoes[index]);
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              RequestInfoDialog(
                                                  notificacoes[index]
                                                      .solicitacao!.objectId!));
                                    },
                                  ),
                                ),
                                )
                        : Center(
                          child: SizedBox(
                                  height: 25,
                                  child: Text(
                                    "Você ainda não tem notificações.",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue[300],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ]),
                ),
              );
          }
        });
  }

  Future<List<Notificacao>?> getNotificacoes() async {
    return await notificacaoController.getAllNotificacoes();
  }

  void marcarComoVisto(Notificacao notificacao) {
    if (!notificacao.visto!) {
      setState(() {
        notificacao.visto = true;
        notificacaoController.editarNotificacao(notificacao);
      });
    }
  }
}
