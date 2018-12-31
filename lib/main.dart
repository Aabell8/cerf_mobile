import 'package:cerf_mobile/constants/themes.dart';
import 'package:cerf_mobile/pages/SchedulePage.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:cerf_mobile/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  VissTheme _theme;

  @override
  void initState() {
    super.initState();
    _theme = kDarkVissTheme;
  }

  void _handleThemeChanged() {
    setState(() {
      _theme = _theme == kDarkVissTheme ? kLightVissTheme : kDarkVissTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Viss',
        debugShowCheckedModeBanner: false,
        theme: _theme.data,
        home: SchedulePage(
          onThemeChanged: _handleThemeChanged,
        ),
      ),
    );
  }
}
