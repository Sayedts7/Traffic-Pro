import 'package:flutter/material.dart';

class ImageFullscreen extends StatelessWidget {
  final String imageUrl;

  const ImageFullscreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Hero(
        tag: imageUrl,
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          width: MediaQuery.of(context).size.width,
          height:MediaQuery.of(context).size.height,
        ),
      )
    );
  }
}