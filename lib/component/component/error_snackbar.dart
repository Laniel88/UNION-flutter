import 'package:flutter/material.dart';

SnackBar errorSnackBar(String error) {
  return SnackBar(
    content: Text(
      error,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 17.0,
        fontFamily: 'Lato',
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    ),
    duration: const Duration(milliseconds: 750),
    backgroundColor: const Color(0xB3FA8072),
  );
}
