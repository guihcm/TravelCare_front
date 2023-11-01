import 'package:flutter/material.dart';

class MyDialog extends StatelessWidget {
  final String content;
  final Function() onPressed;

  const MyDialog(this.content, this.onPressed, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(content,),
      actions: <Widget>[
        Center(
            child: ElevatedButton(
          onPressed: onPressed,
          child: const Text("Ok"),
        ))
      ],
    );
  }
}
