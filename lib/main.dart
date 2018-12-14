import 'package:flutter/material.dart';
import 'package:cerf_mobile/pages/SchedulePage.dart';
import 'package:cerf_mobile/constants/colors.dart';

void main() {
  // MapView.setApiKey(Strings.gMapsAPI);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cerf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: AppColors.greenBlue,
        accentColor: AppColors.blueAccent,
        buttonColor: AppColors.greenBlue,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        // primaryColorBrightness: Brightness.dark,
        secondaryHeaderColor: AppColors.greenBlue,
      ),
      home: SchedulePage(),
    );
  }
}
