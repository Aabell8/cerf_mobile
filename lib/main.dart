import 'package:cerf_mobile/pages/RootPage.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Viss',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: AppColors.greenBlue,
          accentColor: AppColors.blueAccent,
          buttonColor: AppColors.greenBlue,
          buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          // brightness: Brightness.dark,
          // primaryColorBrightness: Brightness.dark,
          secondaryHeaderColor: AppColors.greenBlue,
        ),
        home: RootPage(),
      ),
    );
  }
}
