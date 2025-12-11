import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isGradient;

  const AppButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xFFFF9800),
    this.foregroundColor = Colors.white,
    this.isGradient = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isGradient) {
      return Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFCC80), Color(0xFFFF9800)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(10.0),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: foregroundColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: foregroundColor,
        backgroundColor: backgroundColor,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(text),
    );
  }
}