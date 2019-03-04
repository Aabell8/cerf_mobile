import 'package:flutter/material.dart';

class DetailsButton extends StatelessWidget {
  DetailsButton({
    Key key,
    this.icon,
    this.text,
    this.onPressed,
    this.condensed = false,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final VoidCallback onPressed;
  final bool condensed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Expanded(
      child: Column(
        children: <Widget>[
          SizedBox(
            width: condensed ? 44.0 : 72.0,
            height: condensed ? 44.0 : 72.0,
            child: IconButton(
              icon: Icon(icon, size:condensed ? 30.0 : 40.0),
              color: themeData.primaryColor,
              onPressed: onPressed,
            ),
          ),
          Text(text),
        ],
      ),
    );
  }
}
