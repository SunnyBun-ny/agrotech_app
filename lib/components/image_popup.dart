
import 'package:flutter/material.dart';

class ImagePopup extends StatefulWidget {
  final ImageProvider<Object> imageFile;
  final double? width;
  final double? height;
  const ImagePopup(
      {super.key, required this.imageFile, this.width, this.height});

  @override
  State<ImagePopup> createState() => _ImagePopupState();
}

class _ImagePopupState extends State<ImagePopup> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        InkWell(
            splashColor: Colors.black26,
            onTap: () => _showImagePopup(context),
            child: Ink.image(
              image: widget.imageFile,
              height: widget.height,
              width: widget.width,
              fit: BoxFit.contain,
            )),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [BoxShadow()],
                  borderRadius: BorderRadius.circular(100)),
              child: const Icon(
                Icons.open_in_full_sharp,
                size: 16,
              )),
        ),
      ],
    );
  }

  void _showImagePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context); // Close the dialog when tapped
            },
            child: Container(
              width: double.infinity,
              height: 300,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.imageFile,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
