import 'package:cerf_mobile/components/settings/VissOptions.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/pages/AuthPage.dart';
import 'package:cerf_mobile/pages/SchedulePage.dart';
import 'package:cerf_mobile/services/auth.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';

class RootPage extends StatefulWidget {
  RootPage({this.options, this.onOptionsChanged});

  final VissOptions options;
  final ValueChanged<VissOptions> onOptionsChanged;

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
      auth.currentUser().then((response) {
        setState(() {
          authStatus = response['user'] == null
              ? AuthStatus.notSignedIn
              : AuthStatus.signedIn;
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
    Auth auth = AuthProvider.of(context).auth;
    auth.logout();
    setState(() {
      authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.theme == null) {
      return _buildWaitingScreen();
    }
    switch (authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return AuthPage(onSignedIn: _signedIn);
      case AuthStatus.signedIn:
        return SchedulePage(
          onSignedOut: _signedOut,
          options: widget.options,
          onOptionsChanged: widget.onOptionsChanged,
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
