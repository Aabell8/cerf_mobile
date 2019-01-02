import 'package:cerf_mobile/components/settings/VissOptions.dart';
import 'package:cerf_mobile/constants/themes.dart';
import 'package:cerf_mobile/pages/SchedulePage.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import 'package:cerf_mobile/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  VissOptions _options;

  @override
  void initState() {
    super.initState();
    _options = VissOptions(
      theme: kDarkVissTheme,
      platform: defaultTargetPlatform,
    );
  }

  void _handleOptionsChanged(VissOptions newOptions) {
    setState(() {
      _options = newOptions;
    });
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
