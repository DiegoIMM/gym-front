import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotFound extends StatelessWidget {
  NotFound({this.text = "No se ha encontrado lo que buscas...", Key? key})
      : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Volver"),
          ),
          TextButton(
            onPressed: () => context.go('/inicio'),
            child: const Text("Puedes volver al incio"),
          ),
        ],
      ),
    );
  }
}
