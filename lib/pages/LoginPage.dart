import 'package:flutter/material.dart';
import 'package:cerf_mobile/constants/colors.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();

  Widget _homePage() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: AppColors.greenBlue,
        // image: DecorationImage(
        //   colorFilter: ColorFilter.mode(
        //       Colors.black.withOpacity(0.1), BlendMode.dstATop),
        //   image: AssetImage('assets/images/mountains.jpg'),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 120.0),
              child: Center(
                child: Image.asset(
                  'assets/viss_white.png',
                  width: 160.0,
                  height: 160.0,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Viss",
                    style: TextStyle(color: Colors.white, fontSize: 40.0),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40.0,
            ),
            Expanded(child: SizedBox()),
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    child: Text(
                      "REGISTER",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15.0,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: () => gotoSignup(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: AppColors.greenBlue,
                      ),
                    ),
                    color: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    onPressed: () => gotoLogin(),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }

  Widget _loginPage() {
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
                key: Key('email'),
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
                key: Key('password'),
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
                      onPressed: () => {},
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

  Widget _signupPage() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        color: Colors.white,
        // image: DecorationImage(
        //   colorFilter: ColorFilter.mode(
        //       Colors.black.withOpacity(0.05), BlendMode.dstATop),
        //   image: AssetImage('assets/images/mountains.jpg'),
        //   fit: BoxFit.cover,
        // ),
      ),
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(vertical: 60.0),
            child: Center(
              child: Image.asset(
                'assets/viss_icon.png',
                width: 120.0,
                height: 120.0,
              ),
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "EMAIL",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenBlue,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: AppColors.greenBlue,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter email here',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "PASSWORD",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenBlue,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: AppColors.greenBlue,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 40.0),
                  child: Text(
                    "CONFIRM PASSWORD",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenBlue,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: AppColors.greenBlue,
                    width: 0.5,
                    style: BorderStyle.solid),
              ),
            ),
            padding: const EdgeInsets.only(left: 0.0, right: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    obscureText: true,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '*********',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 24.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: FlatButton(
                  child: Text(
                    "Already have an account?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.greenBlue,
                      fontSize: 15.0,
                    ),
                    textAlign: TextAlign.end,
                  ),
                  onPressed: () => {},
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(left: 30.0, right: 30.0, top: 50.0),
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    color: AppColors.greenBlue,
                    onPressed: () => {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 20.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "SIGN UP",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
      curve: Curves.bounceOut,
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
            children: <Widget>[_loginPage(), _homePage(), _signupPage()],
            scrollDirection: Axis.horizontal,
          )),
    );
  }
}
