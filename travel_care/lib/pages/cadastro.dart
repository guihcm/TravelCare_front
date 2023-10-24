import 'package:flutter/material.dart';
import 'package:travel_care/components/myAppBar.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar("TRAVELCARE"),
        body: Center(
            child: Column(
          children: [
            Container(
              width: 305,
              height: 326,
              child: Stack(
                children: [
                  TextField(
                    controller: null,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter a valid ZIP-Code',
                      labelText: "ZIP-Code",
                      prefixText: "DE - ",
                      suffixIcon: Icon(Icons.airport_shuttle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )));
  }
}
