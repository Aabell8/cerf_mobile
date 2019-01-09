import 'dart:async';

import 'package:cerf_mobile/components/ScheduleAppBar.dart';
import 'package:cerf_mobile/components/settings/VissOptions.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/pages/NewTaskPage.dart';
import 'package:cerf_mobile/pages/SettingsPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/components/TaskListItem.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage(
      {Key key, this.options, this.onSignedOut, this.onOptionsChanged})
      : super(key: key);

  final VissOptions options;
  final ValueChanged<VissOptions> onOptionsChanged;
  final VoidCallback onSignedOut;

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  List<Task> tasks = testTasks.toList();
  bool _isStarted = false;

  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = new Location();

  void initState() {
    super.initState();
    _isStarted = false;
  }

  initPlatformState() async {
    Map<String, double> location;
    try {
      await _location.hasPermission();
      location = await _location.getLocation();
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        showSnackBarMessage(
            'Permission denied for retrieving location, please enable it in settings');
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        // This logic statement doesn't seem to be reachable
        print('Permission not asked for and not allowed yet');
      }
      location = null;
    }

    print(location);
  }

  Widget buildListTile(Task item) {
    return TaskListItem(item, context);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Task item = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, item);
    });
  }

  void onStarted() async {
    await initPlatformState();
    setState(() {
      _locationSubscription =
          _location.onLocationChanged().listen((Map<String, double> result) {
        print(result);
        setState(() {
          _currentLocation = result;
        });
      });
      _isStarted = true;
    });
  }

  void onPaused() {
    setState(() {
      _locationSubscription.cancel();
      _isStarted = false;
    });
  }

  showSnackBarMessage(String text) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text("Schedule"),
          backgroundColor: isDark ? Colors.grey[900] : null,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => _goToSettings(),
            )
          ],
          bottom: ScheduleAppBar(
            dark: isDark,
            isStarted: _isStarted,
            onStart: onStarted,
            onPause: onPaused,
          )),
      body: Scrollbar(
        child: _isStarted
            ? ListView(
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: tasks.map(buildListTile).toList(),
              )
            : ReorderableListView(
                onReorder: _onReorder,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: tasks.map(buildListTile).toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewTask().then((item) {
            if (item != null) {
              tasks.add(item);
              print("Added item: ${item.address}");
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.blueAccent,
      ),
    );
  }

  Future<Task> _createNewTask() async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => NewTaskPage(),
        ));
  }

  void _goToSettings() async {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => SettingsPage(
                options: widget.options,
                onOptionsChanged: widget.onOptionsChanged,
                onSignedOut: widget.onSignedOut,
              ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _locationSubscription.cancel();
    super.dispose();
  }
}

typedef TimeCallback = Future<Task> Function();
