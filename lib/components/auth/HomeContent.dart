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
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: AppColors.greenBlue,
            // image: DecorationImage(
            //   colorFilter: ColorFilter.mode(
            //     Colors.black.withOpacity(0.1), BlendMode.dstATop),
            //   image: AssetImage('images/.jpg'),
            //   fit: BoxFit.fitHeight,
            // ),
          ),
        ),
        Positioned(
          bottom: 40.0,
          left: 16.0,
          right: 16.0,
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  child: Text(
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
        ),
        Positioned(
          bottom: 106.0,
          left: 16.0,
          right: 16.0,
          child: Row(
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
                  borderSide: BorderSide(color: Colors.white),
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  onPressed: () => widget.gotoSignup(),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 370.0,
          left: 16.0,
          right: 16.0,
          child: Image.asset(
            'assets/viss_white.png',
            width: 140.0,
            height: 140.0,
          ),
        ),
        Positioned(
          bottom: 300.0,
          left: 16.0,
          right: 16.0,
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
      ],
    );
  }
}
