import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/material.dart';

class SignupContent extends StatefulWidget {
  SignupContent(
      {Key key, this.gotoLogin, this.onSignedIn, this.onSnackBarMessage})
      : super(key: key);

  final VoidCallback gotoLogin;
  final VoidCallback onSignedIn;
  final Function onSnackBarMessage;

  _SignupContentState createState() => _SignupContentState();
}

class _SignupContentState extends State<SignupContent> {
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  Map<String, dynamic> credentials = {
    "name": "",
    "email": "",
    "password": "",
    "passwordConfirm": "",
  };
  TextEditingController _passwordController = TextEditingController();

  String _validateName(String value) {
    value = value.trim();
    if (value.isEmpty) return 'Name is required.';
    return null;
  }

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
    if (value.length < 8) return "Password must be at least 8 characters";
    String p = r'^(?=\S*[a-z])(?=\S*[A-Z])(?=\S*\d).*$';

    RegExp regExp = new RegExp(p);

    if (!regExp.hasMatch(value))
      return "Password must have capital letter and digit";
    if (value.isEmpty) return 'Password is required.';
    return null;
  }

  String _validatePasswordConfirm(String value) {
    value = value.trim();
    if (value.isEmpty) return 'Password is required.';
    if (value != _passwordController.text) return "Passwords do not match";
    return null;
  }

  bool _validateAndSave() {
    final form = _signupFormKey.currentState;
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

        Map<String, String> response = await auth.createUser(
            credentials["name"], credentials["email"], credentials["password"]);
        // await auth.createUser("name", "Austin6@gmail.com", "Testing123");

        if (response['error'] != null) {
          print(response);
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
        key: _signupFormKey,
        autovalidate: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Center(
                  child: Image.asset(
                    'assets/viss_icon.png',
                    width: 100.0,
                    height: 100.0,
                  ),
                ),
              ),
              TextFormField(
                key: Key('name'),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name *',
                ),
                onSaved: (String value) {
                  credentials["name"] = value;
                },
                validator: _validateName,
                // validator: _validateAddress,
                maxLines: 1,
              ),
              SizedBox(
                height: 24.0,
              ),
              TextFormField(
                key: Key('signup_email'),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email *',
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
                key: Key('signup_password'),
                controller: _passwordController,
                obscureText: true,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password *',
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
              TextFormField(
                key: Key('signup_confirm_password'),
                obscureText: true,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password *',
                ),
                onSaved: (String value) {
                  credentials["passwordConfirm"] = value;
                },
                validator: _validatePasswordConfirm,
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
                      "Already have an account?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.greenBlue,
                        fontSize: 15.0,
                      ),
                      textAlign: TextAlign.end,
                    ),
                    onPressed: () => widget.gotoLogin(),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      key: Key('register'),
                      child: Text('SIGN UP'),
                      color: Theme.of(context).primaryColor,
                      padding: EdgeInsets.symmetric(vertical: 16.0),
                      onPressed: _validateAndSubmit,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
