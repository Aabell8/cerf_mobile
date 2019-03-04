import 'package:cerf_mobile/constants/colors.dart';
import 'package:flutter/material.dart';

class VissTheme {
  const VissTheme._(this.name, this.data);

  final String name;
  final ThemeData data;
}

final VissTheme kDarkVissTheme = VissTheme._('Dark', _buildDarkTheme());
final VissTheme kLightVissTheme = VissTheme._('Light', _buildLightTheme());

ThemeData _buildDarkTheme() {
  const Color primaryColor = AppColors.greenBlue;
  const Color secondaryColor = AppColors.blueAccent;
  final ThemeData base = ThemeData.dark();
  final ColorScheme colorScheme = const ColorScheme.dark().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  return base.copyWith(
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    accentColor: secondaryColor,
    canvasColor: const Color(0xFF202124),
    scaffoldBackgroundColor: const Color(0xFF202124),
    backgroundColor: const Color(0xFF202124),
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}

ThemeData _buildLightTheme() {
  const Color primaryColor = AppColors.greenBlue;
  const Color secondaryColor = AppColors.blueAccent;
  final ColorScheme colorScheme = const ColorScheme.light().copyWith(
    primary: primaryColor,
    secondary: secondaryColor,
  );
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: colorScheme,
    primaryColor: primaryColor,
    buttonColor: primaryColor,
    indicatorColor: Colors.white,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    accentColor: secondaryColor,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    errorColor: const Color(0xFFB00020),
    buttonTheme: ButtonThemeData(
      colorScheme: colorScheme,
      textTheme: ButtonTextTheme.primary,
    ),
  );
}
