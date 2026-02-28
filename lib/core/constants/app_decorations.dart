import 'package:flutter/material.dart';

class AppDecorations {
  AppDecorations._();

  static const cardShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.05),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const cardBorderRadius = BorderRadius.all(Radius.circular(16));

  static const dateBlue = Color(0xFF1E88E5);
  static const dateOrange = Color(0xFFFB8C00);
}
