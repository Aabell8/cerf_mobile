import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const _greenBluePrimary = 0xFF2CA579;
  static const _blueAccent = 0xFF00ACC1;

  static const MaterialColor greenBlue = const MaterialColor(
    _greenBluePrimary,
    const <int, Color>{
      50: const Color(0xFF65D7A8),
      100: const Color(_greenBluePrimary),
      200: const Color(_greenBluePrimary),
      300: const Color(_greenBluePrimary),
      400: const Color(_greenBluePrimary),
      500: const Color(_greenBluePrimary),
      600: const Color(_greenBluePrimary),
      700: const Color(_greenBluePrimary),
      800: const Color(_greenBluePrimary),
      900: const Color(0xFF00754D),
    },
  );

  static const MaterialColor blueAccent = const MaterialColor(
    _blueAccent,
    const <int, Color>{
      50: const Color(0xFF5DDEF4),
      100: const Color(_blueAccent),
      200: const Color(_blueAccent),
      300: const Color(_blueAccent),
      400: const Color(_blueAccent),
      500: const Color(_blueAccent),
      600: const Color(_blueAccent),
      700: const Color(_blueAccent),
      800: const Color(_blueAccent),
      900: const Color(0xFF007C91),
    },
  );
}
