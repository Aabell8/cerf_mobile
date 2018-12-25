import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/pages/AuthPage.dart';
import 'package:cerf_mobile/pages/SchedulePage.dart';
import 'package:cerf_mobile/services/auth.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootPageState();
}

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.notDetermined;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Auth auth = AuthProvider.of(context).auth;
    if (authStatus == AuthStatus.notDetermined) {
      auth.currentUser().then((userId) {
        setState(() {
          authStatus =
              userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
        });
      });
    }
  }

  void _signedIn() {
    setState(() {
      authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return AuthPage(onSignedIn: _signedIn);
      case AuthStatus.signedIn:
        return SchedulePage(
            onSignedOut: _signedOut,
            );
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.greenBlue,
          // image: DecorationImage(
          //   colorFilter: ColorFilter.mode(
          //       Colors.black.withOpacity(0.1), BlendMode.dstATop),
          //   image: AssetImage('assets/images/mountains.jpg'),
          //   fit: BoxFit.cover,
          // ),
        ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 100.0),
              child: Center(
                child: Image.asset(
                  'assets/viss_white.png',
                  width: 160.0,
                  height: 160.0,
                ),
              ),
            ),
            Expanded(child: SizedBox(height: 16.0)),
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            Expanded(
              child: SizedBox(
                height: 50.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
