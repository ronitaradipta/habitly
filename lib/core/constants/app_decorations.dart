import 'package:flutter/material.dart';

class AppDecorations {
  AppDecorations._();

  static const cardShadow = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.05),
    blurRadius: 8,
    offset: Offset(0, 2),
  );

  static const cardBorderRadius = BorderRadius.all(Radius.circular(16));
}
