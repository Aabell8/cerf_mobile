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

        Map<String, String> response =
            await auth.createUserWithEmailAndPassword("Not", "implemented");
        print('Registered user: ${response['user']}');
        if (response['user'] != null) {
          widget.onSignedIn();
        }
      } catch (e) {
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
                key: Key('signup_email'),
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
                key: Key('signup_password'),
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
              TextFormField(
                key: Key('signup_confirm_password'),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Confirm Password',
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
                      child: const Text('SIGN UP'),
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
