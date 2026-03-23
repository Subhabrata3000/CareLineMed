// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';

class FontFamily {
  static const String gilroyBlack = "Gilroy Black";
  static const String gilroyLight = "Gilroy Light";
  static const String gilroyHeavy = "Gilroy Heavy";
  static const String gilroyMedium = "Gilroy Medium";
  static const String gilroyBold = "Gilroy Bold";
  static const String gilroyExtraBold = "Gilroy ExtraBold";
  static const String gilroyRegular = "Gilroy Regular";
  static const String poppins = "Poppins";          // New: Poppins
}

class gradient {
  // Primary Gradient: Linear from Teal #00A89F to Dark Teal #007A73
  static const Gradient btnGradient = LinearGradient(
    colors: [Color(0xFF00A89F), Color(0xFF007A73)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  // Splash Gradient: #007A73 -> #00A89F -> #00BFA5
  static const Gradient splashGradient = LinearGradient(
    colors: [Color(0xFF007A73), Color(0xFF00A89F), Color(0xFF00BFA5)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const Gradient greenGradient = LinearGradient(
    colors: [Color(0xFF00A89F), Color(0xFF00A89F)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const Gradient lightGradient = LinearGradient(
    colors: [Color(0xFFE1F0F0), Color(0xFFE1F0F0)],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  static const Gradient transpharantGradient = LinearGradient(
    colors: [Colors.transparent, Colors.transparent],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );
  static const Color defoultColor = Color(0xFF00A89F);
}
