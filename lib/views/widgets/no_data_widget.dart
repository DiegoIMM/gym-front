import 'package:flutter/material.dart';

class NoData extends StatelessWidget {
  NoData({this.text = "No hay datos creados aún...", Key? key})
      : super(key: key);
  String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error,
            size: 100,
          ),
          Text(text),
        ],
      ),
    );
  }
}
