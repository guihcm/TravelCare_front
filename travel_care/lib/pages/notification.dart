import 'package:flutter/material.dart';
import 'package:travel_care/models/notificacao.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notificacao> notifications = [
    Notificacao(
      texto: 'Sua solicitação para Goiânia foi aceita.',
      visto: false,
    ),
    Notificacao(
      texto: 'Sua solicitação para Anápolis foi recusada.',
      visto: false,
    ),
    Notificacao(
      texto: 'Sua solicitação para Goiânia foi aceita.',
      visto: true,
    ),
    Notificacao(
      texto: 'Sua solicitação para Anápolis foi recusada.',
      visto: true,
    ),
    Notificacao(
      texto: 'Sua solicitação para Goiânia foi aceita.',
      visto: true,
    ),
    Notificacao(
      texto: 'Sua solicitação para Anápolis foi recusada.',
      visto: true,
    ),
    Notificacao(
      texto: 'Bem vindo ao TravelCare.',
      visto: true,
    ),
    Notificacao(
      texto: 'Sua solicitação para Goiânia foi aceita.',
      visto: false,
    ),
    Notificacao(
      texto: 'Sua solicitação para Anápolis foi recusada.',
      visto: false,
    ),
    Notificacao(
      texto: 'Sua solicitação para Goiânia foi aceita.',
      visto: true,
    ),
    Notificacao(
      texto: 'Sua solicitação para Anápolis foi recusada.',
      visto: true,
    ),
    Notificacao(
      texto: 'Sua solicitação para Goiânia foi aceita.',
      visto: true,
    ),
    Notificacao(
      texto: 'Sua solicitação para Anápolis foi recusada.',
      visto: true,
    ),
    Notificacao(
      texto: 'Bem vindo ao TravelCare.',
      visto: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
              child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.white10,
                            child: notifications[index].visto
                                ? const Icon(Icons.notifications_none)
                                : const Icon(Icons.notifications_active),
                          ),
                          tileColor: notifications[index].visto
                              ? Colors.white
                              : Colors.grey[200],
                          title: notifications[index].visto
                              ? Text(notifications[index].texto)
                              : Text(
                                  notifications[index].texto,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                          trailing: PopupMenuButton<String>(
                            itemBuilder: (BuildContext context) {
                              return {'Marcar como visto', 'Apagar'}
                                  .map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(
                                    choice,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                );
                              }).toList();
                            },
                            onSelected: (String choice) {
                              if (choice == 'Marcar como visto') {
                                marcarComoVisto(index);
                              } else if (choice == 'Apagar') {
                                apagar(index);
                              }
                            },
                            color: Colors.blue,
                          ),
                          onTap: () => marcarComoVisto(index),
                        ),
                      )),
            ),
          ),
        ]),
      ),
    );
  }

  void marcarComoVisto(int index) {
    setState(() {
      notifications[index].visto = true;
    });
  }

  void apagar(int index) {
    setState(() {
      notifications.removeAt(index);
    });
  }
}
