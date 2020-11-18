import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PkuReader(),
  ));
}

class PkuReader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Text(
        'Welcome to PKU Reader',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      )),
    );
  }
}
