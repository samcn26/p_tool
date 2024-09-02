import 'package:flutter/material.dart';

class ImageTool extends StatelessWidget {
  static String path = "/image-tool";
  const ImageTool({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text( "Image Tool")),
      body: const Text("Image Tool"),
    );
  }
}
