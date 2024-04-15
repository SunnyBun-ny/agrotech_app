import 'package:flutter/material.dart';

class CustomIconButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  const CustomIconButton(
      {super.key,
      required this.label,
      required this.icon,
      required this.onPressed});

  @override
  State<CustomIconButton> createState() => _CustomIconButtonState();
}

class _CustomIconButtonState extends State<CustomIconButton> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        textTheme: Theme.of(context).buttonTheme.textTheme,
        color: Theme.of(context).primaryColorLight,
        // color: Color(0xffd3e8d6),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        onPressed: widget.onPressed,
        child: Row(
          children: [
            Icon(widget.icon),
            const SizedBox(width: 12),
            Text(widget.label)
          ],
        ));
  }
}
