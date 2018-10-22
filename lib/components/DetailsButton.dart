import 'package:flutter/material.dart';

class DetailsButton extends StatelessWidget {
  const DetailsButton({Key key, this.icon, this.text, this.onPressed})
      : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Expanded(
      child: new Column(
        children: <Widget>[
          new SizedBox(
            width: 72.0,
            height: 72.0,
            child: new IconButton(
              icon: new Icon(icon, size: 40.0),
              color: themeData.primaryColor,
              onPressed: onPressed,
            ),
          ),
          new Text(text),
        ],
      ),
    );
  }
}
