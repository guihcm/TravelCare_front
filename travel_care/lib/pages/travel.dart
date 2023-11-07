
import 'package:flutter/material.dart';
import 'package:travel_care/pages/home.dart';

class TravelPage extends StatefulWidget {
  const TravelPage({super.key});
  @override
  State<TravelPage> createState() => _TravelPageState();
}

class _TravelPageState extends State<TravelPage> {
  //List cidades = ["Ceres", "Itapaci", "São Patrício", "Ceres", "Itapaci", "São Patrício"];
  List cidades = ["Ceres"];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(children: [
          const SizedBox(height: 30),
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
                  child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
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
                        SizedBox(height: 10),
                        Row(
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
                        SizedBox(height: 10),
                        Row(
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
                        TextButton(
                          onPressed: info(),
                          child: Text(
                            '...',
                            style: TextStyle(
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 170),
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
    void info() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => const HomePage()));
}
  void solicitar() {
    Navigator.push(
      context, MaterialPageRoute(builder: (context) => const HomePage()));
}
}



