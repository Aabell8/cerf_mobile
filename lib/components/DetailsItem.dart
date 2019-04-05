import 'package:flutter/material.dart';

class DetailsItem extends StatelessWidget {
  DetailsItem({
    Key key,
    this.leftIcon,
    this.icon,
    this.lines,
    this.tooltip,
    this.onPressed,
  })  : assert(lines.length > 1),
        super(key: key);

  final IconData icon;
  final IconData leftIcon;
  final List<String> lines;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final List<Widget> columnChildren = lines
        .sublist(0, lines.length - 1)
        .map((String line) => Text(line))
        .toList();
    columnChildren.add(Text(lines.last, style: themeData.textTheme.caption));

    final List<Widget> rowChildren = <Widget>[
      leftIcon != null
          ? SizedBox(
              width: 72.0,
              child: Icon(
                leftIcon,
                color: themeData.primaryColor,
              ),
            )
          : Container(width: 72.0),
      Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: columnChildren)),
      icon != null
          ? SizedBox(
              width: 72.0,
              child: IconButton(
                  icon: Icon(icon),
                  color: themeData.primaryColor,
                  onPressed: onPressed))
          : Container(),
    ];

    return MergeSemantics(
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: rowChildren)),
    );
  }
}
