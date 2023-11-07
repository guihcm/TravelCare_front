import 'package:flutter/material.dart';
import 'package:travel_care/components/myDialog.dart';
import 'package:travel_care/pages/home.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});
  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  List cidades = [
    "Ceres",
    "Itapaci",
    "São Patrício",
    "Ceres",
    "Itapaci",
    "São Patrício"
  ];
  //List cidades = ["Ceres"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20),
        child: Column(children: [
          const SizedBox(height: 40),
          const Text(
            'Minhas Solicitações:',
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
                itemCount: cidades.length,
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                  cidades[index],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Text(
                                  'Data: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '01/11/2023',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Text(
                                  'Situação: ',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Aceita',
                                  style: TextStyle(
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
                                  onPressed: () => info(),
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
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 170, bottom: 25),
            child: ElevatedButton(
                onPressed: () => solicitar(),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ))),
                child: const Text('Solicitar Viagem',
                    style: TextStyle(
                      fontSize: 22,
                    ))),
          ),
        ]),
      ),
    );
  }

  info() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Paciente: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Leonardo",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Acompanhante: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Não',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      'Destino: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Goiânia',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                  child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Voltar"),
              ))
            ],
          );
        });
  }

  void solicitar() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }
}
