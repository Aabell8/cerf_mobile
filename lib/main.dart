import 'package:cerf_mobile/pages/RootPage.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';

import 'package:cerf_mobile/pages/SchedulePage.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final Auth auth = Auth();
    // auth
    //     .loginWithEmailAndPassword("Austin6@gmail.com", "Testing123")
    //     .then((res) {
    //   print(res);
    //   auth.currentUser().then((res) {
    //     print(res);
    //   });
    // });
    // auth.currentUser().then((res) => print(res));

    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Cerf',
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
