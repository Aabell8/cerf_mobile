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

  Map<String, dynamic> credentials = {
    "name": "",
    "email": "",
    "password": "",
  };

    String _validateEmail(String value) {
    value = value.trim();
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    if (!regExp.hasMatch(value)) return "Not a valid email";
    if (value.isEmpty) return 'Email is required.';
    return null;
  }

    String _validatePassword(String value) {
    value = value.trim();
    if (value.isEmpty) return 'Password is required.';
    return null;
  }

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
            credentials["email"], credentials["password"]);
        // "Austin6@gmail.com", "Testing123");

        if (response['error'] != null) {
          widget.onSnackBarMessage("Error in signing in: ${response['error']}");
        } else if (response['user'] != null) {
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
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
                onSaved: (String value) {
                  credentials["email"] = value;
                },
                validator: _validateEmail,
                maxLines: 1,
              ),
              SizedBox(
                height: 24.0,
              ),
              TextFormField(
                key: Key('login_password'),
                obscureText: true,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
                onSaved: (String value) {
                  credentials["password"] = value;
                },
                validator: _validatePassword,
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
