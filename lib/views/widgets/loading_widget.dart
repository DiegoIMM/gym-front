import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  LoadingWidget({this.text = "Cargando...", Key? key}) : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(text),
        ],
      ),
    );
  }
}
