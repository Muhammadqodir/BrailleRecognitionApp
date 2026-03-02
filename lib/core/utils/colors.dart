import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF3EAFEA);
const Color primaryColor1 = Color(0xFF79C3E6);

const Gradient primaryGradient = LinearGradient(
  colors: [primaryColor, primaryColor1],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

BoxShadow shadowPrimary = const BoxShadow(
  color: primaryColor,
  spreadRadius: 0.8,
  blurRadius: 5,
  offset: Offset(0, 5),
);