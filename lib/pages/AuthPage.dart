import 'package:cerf_mobile/components/auth/HomeContent.dart';
import 'package:cerf_mobile/components/auth/LoginContent.dart';
import 'package:cerf_mobile/components/auth/SignupContent.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  AuthPage({this.onSignedIn});

  final VoidCallback onSignedIn;

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  gotoLogin() {
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 600),
      curve: Curves.decelerate,
    );
  }

  gotoSignup() {
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.decelerate,
    );
  }

  PageController _controller =
      PageController(initialPage: 1, viewportFraction: 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _controller,
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              LoginContent(
                onSignedIn: widget.onSignedIn,
              ),
              HomeContent(
                gotoLogin: gotoLogin,
                gotoSignup: gotoSignup,
              ),
              SignupContent(
                gotoLogin: gotoLogin,
                onSignedIn: widget.onSignedIn,
              ),
            ],
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}
