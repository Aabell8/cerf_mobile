import 'package:flutter/material.dart';
import 'dart:async';

class TaskWindowPicker extends StatelessWidget {
  const TaskWindowPicker({
    this.windowStart,
    this.windowEnd,
    this.selectStartTime,
    this.selectEndTime,
  });

  final TimeOfDay windowStart;
  final TimeOfDay windowEnd;
  final TimeCallback selectStartTime;
  final TimeCallback selectEndTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: _InputDropdown(
            labelText: "Start Time",
            valueText: windowStart.format(context),
            onPressed: () {
              selectStartTime(context);
            },
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            labelText: "End Time",
            valueText: windowEnd.format(context),
            onPressed: () {
              selectEndTime(context);
            },
          ),
        ),
      ],
    );
  }
}

typedef TimeCallback = Future<Null> Function(BuildContext context);

class _InputDropdown extends StatelessWidget {
  const _InputDropdown(
      {Key key,
      this.child,
      this.labelText,
      this.valueText,
      this.valueStyle,
      this.onPressed})
      : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.grey.shade700
                    : Colors.white70),
          ],
        ),
      ),
    );
  }
}
