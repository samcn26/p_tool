import 'package:flutter/material.dart';

class Tool2 extends StatelessWidget {
  static String path = '/tool2';
  const Tool2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: true, title: const Text("tool 2"),),
      body:  const Text("tool 2")
    );
  }
}
