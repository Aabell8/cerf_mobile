import 'package:cerf_mobile/components/settings/VissOptions.dart';
import 'package:cerf_mobile/constants/themes.dart';
import 'package:cerf_mobile/pages/SchedulePage.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import 'package:cerf_mobile/services/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

const _themeKey = "theme_option";

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  VissOptions _options;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  void _getOptions() async {
    final SharedPreferences prefs = await _prefs;

    bool _theme = prefs.getBool(_themeKey);
    if (_theme != null && _theme) {
      setState(() {
        _options = _options.copyWith(theme: kDarkVissTheme);
      });
    }
  }

  void _setOptions(VissOptions options) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool(_themeKey, options.theme == kDarkVissTheme);
  }

  @override
  void initState() {
    super.initState();
    _options = VissOptions(
      theme: kLightVissTheme,
      platform: defaultTargetPlatform,
    );
    _getOptions();
  }

  void _handleOptionsChanged(VissOptions newOptions) {
    setState(() {
      _options = newOptions;
    });
    _setOptions(newOptions);
  }

  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Viss',
        debugShowCheckedModeBanner: false,
        theme: _options.theme.data.copyWith(platform: _options.platform),
        home: SchedulePage(
          options: _options,
          onOptionsChanged: _handleOptionsChanged,
        ),
      ),
    );
  }
}
