import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  final VoidCallback onImageClicked;
  final CameraController controller;
  const CameraScreen(
      {super.key, required this.onImageClicked, required this.controller});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  @override
  Widget build(BuildContext context) {
    if (!widget.controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Camera')),
        body: CameraPreview(widget.controller),
        floatingActionButton: FloatingActionButton(
          onPressed: widget.onImageClicked,
          child: const Icon(Icons.camera),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // Button for capturing photo
      ),
    );
  }
}
