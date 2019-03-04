import 'package:cerf_mobile/components/settings/VissOptions.dart';
import 'package:cerf_mobile/constants/themes.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({
    Key key,
    this.options,
    this.onOptionsChanged,
    this.onSignedOut,
  }) : super(key: key);

  final VissOptions options;
  final ValueChanged<VissOptions> onOptionsChanged;
  final VoidCallback onSignedOut;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: isDark ? Colors.grey[900] : null,
      ),
      body: ListView(
        padding: EdgeInsets.only(bottom: 124.0),
        children: <Widget>[
          _Heading('Display'),
          _ThemeItem(options, onOptionsChanged),
          Divider(),
          _Heading('Account'),
          _BooleanItem(
            'Update task notes on status update',
            options.updateNotes,
            (bool value) {
              onOptionsChanged(options.copyWith(updateNotes: value));
            },
          ),
          SizedBox(height: 8.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                      key: Key('logoutButton'),
                      child: Text('LOGOUT'),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        onSignedOut();
                        Navigator.pop(context);
                      }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeItem extends StatelessWidget {
  _ThemeItem(this.options, this.onOptionsChanged);

  final VissOptions options;
  final ValueChanged<VissOptions> onOptionsChanged;

  @override
  Widget build(BuildContext context) {
    return _BooleanItem(
      'Dark Theme',
      options.theme == kDarkVissTheme,
      (bool value) {
        onOptionsChanged(
          options.copyWith(
            theme: value ? kDarkVissTheme : kLightVissTheme,
          ),
        );
      },
      switchKey: Key('dark_theme'),
    );
  }
}

class _Heading extends StatelessWidget {
  _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return _OptionsItem(
      child: DefaultTextStyle(
        style: theme.textTheme.body1.copyWith(
          fontFamily: 'GoogleSans',
          color: theme.accentColor,
        ),
        child: Semantics(
          child: Text(text),
          header: true,
        ),
      ),
    );
  }
}

double _kItemHeight = 48.0;

class _OptionsItem extends StatelessWidget {
  _OptionsItem({Key key, this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor = MediaQuery.textScaleFactorOf(context);

    return MergeSemantics(
      child: Container(
        constraints: BoxConstraints(minHeight: _kItemHeight * textScaleFactor),
        padding: EdgeInsets.fromLTRB(32.0, 0, 16.0, 0),
        alignment: AlignmentDirectional.centerStart,
        child: DefaultTextStyle(
          style: DefaultTextStyle.of(context).style,
          maxLines: 2,
          overflow: TextOverflow.fade,
          child: IconTheme(
            data: Theme.of(context).primaryIconTheme,
            child: child,
          ),
        ),
      ),
    );
  }
}

class _BooleanItem extends StatelessWidget {
  _BooleanItem(this.title, this.value, this.onChanged, {this.switchKey});

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  // [switchKey] is used for accessing the switch from driver tests.
  final Key switchKey;

  @override
  Widget build(BuildContext context) {
    return _OptionsItem(
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title)),
          Switch(
            key: switchKey,
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
