import 'package:cerf_mobile/constants/colors.dart';
import 'package:flutter/material.dart';

class HomeContent extends StatefulWidget {
  HomeContent({Key key, this.gotoSignup, this.gotoLogin}) : super(key: key);

  final VoidCallback gotoSignup;
  final VoidCallback gotoLogin;

  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              padding: EdgeInsets.only(top: 100.0),
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
                    onPressed: () => widget.gotoSignup(),
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
                    onPressed: () => widget.gotoLogin(),
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
}
