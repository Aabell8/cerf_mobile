import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';

class LoginContent extends StatefulWidget {
  LoginContent({this.onSignedIn, this.onSnackBarMessage});

  final VoidCallback onSignedIn;
  final Function onSnackBarMessage;

  @override
  _LoginContentState createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

  bool _validateAndSave() {
    final form = _loginFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _validateAndSubmit() async {
    if (_validateAndSave()) {
      try {
        var auth = AuthProvider.of(context).auth;

        Map<String, String> response = await auth.loginWithEmailAndPassword(
            "Austin6@gmail.com", "Testing123");

        if (response['error'] != null) {
          widget.onSnackBarMessage("Error in signing in: ${response['error']}");
        }
        else if (response['user'] != null) {
          widget.onSignedIn();
        } else {
          widget.onSnackBarMessage("User does not exist");
        }
      } catch (e) {
        widget.onSnackBarMessage("Error in logging in");
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Form(
        key: _loginFormKey,
        autovalidate: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 80.0),
                child: Center(
                  child: Image.asset(
                    'assets/viss_icon.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ),
              TextFormField(
                key: Key('login_email'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                onSaved: (String value) {},
                // validator: _validateAddress,
                maxLines: 1,
              ),
              SizedBox(
                height: 24.0,
              ),
              TextFormField(
                key: Key('login_password'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onSaved: (String value) {},
                // validator: _validateAddress,
                maxLines: 1,
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlatButton(
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.greenBlue,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () => {},
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      key: Key('login'),
                      child: const Text('LOGIN'),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      onPressed: _validateAndSubmit,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              // Container(
              //   width: MediaQuery.of(context).size.width,
              //   alignment: Alignment.center,
              //   child: Row(
              //     children: <Widget>[
              //       Expanded(
              //         child: Container(
              //           margin: EdgeInsets.all(8.0),
              //           decoration:
              //               BoxDecoration(border: Border.all(width: 0.25)),
              //         ),
              //       ),
              //       Text(
              //         "OR CONNECT WITH",
              //         style: TextStyle(
              //           color: Colors.grey,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       Expanded(
              //         child: Container(
              //           margin: EdgeInsets.all(8.0),
              //           decoration:
              //               BoxDecoration(border: Border.all(width: 0.25)),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
