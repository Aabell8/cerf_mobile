import 'dart:async';

import 'package:cerf_mobile/components/ScheduleAppBar.dart';
import 'package:cerf_mobile/components/settings/VissOptions.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/pages/NewTaskPage.dart';
import 'package:cerf_mobile/pages/SettingsPage.dart';
import 'package:cerf_mobile/services/tasks.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/components/TaskListItem.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({Key key, this.options, this.onSignedOut, this.onOptionsChanged})
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

  List<Task> tasks = [];
  bool _isStarted;
  String _currentTask;
  bool _isLoading;

  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = Location();

  void initState() {
    super.initState();
    _isStarted = false;
    _isLoading = true;
    updateTasks();
  }

  Future<void> updateTasks() {
    setState(() {
      _isLoading = true;
    });
    return fetchTasks().then<void>((res) {
      setState(() {
        tasks = res;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBarMessage(
          "Error in refreshing data from server: \nError code: $e");
    });
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

    // print(location);
  }

  // List<Task> filterTodo() {
  //   tasksTodo = tasks
  //       .where((task) => (task.status != "f" && task.status != "c"))
  //       .toList();
  //   return tasksTodo;
  // }

  // Returns true if another valid task, false if no tasks to do 
  bool getNextTask() {
    List<Task> todo = tasks
        .where((task) => (task.status != "f" && task.status != "c"))
        .toList();
    if (todo.isNotEmpty) {
      setState(() {
        _currentTask = todo[0].id;
      });
      return true;
    } else {
      setState(() {
        _currentTask = "";
      });
      return false;
    }
  }

  void updateStatus(Task task) {
    // ? Update status on server
    getNextTask();
    // setState(() {
    //   tasksTodo = filterTodo();
    //   _currentTask = tasks.isNotEmpty ? tasksTodo[0]?.id : "";
    // });
  }

  Widget buildListTile(Task item) {
    return TaskListItem(item, context);
  }

  Widget buildExpandedTile(Task item) {
    return ExpandableTaskListItem(
        item, context, _currentTask == item.id, updateStatus);
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
    if (!getNextTask()) {
      showSnackBarMessage("No tasks remaining to be completed today");
      return;
    }
    // ? Send started status to server
    setState(() {
      _locationSubscription =
          _location.onLocationChanged().listen((Map<String, double> result) {
        _currentLocation = result;
      });
      // Filter tasks
      // tasksTodo = filterTodo();
      // _currentTask = tasksTodo.isNotEmpty ? tasksTodo[0]?.id : "";
      _isStarted = true;
    });
  }

  void onPaused() {
    setState(() {
      _locationSubscription.cancel();
      _isStarted = false;
    });
  }

  void onRefresh() {
    updateTasks();
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
            onOptimize: onRefresh,
          )),
      body: !_isLoading
          ? Scrollbar(
              child: _isStarted
                  ? ListView(
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      children: tasks.map(buildExpandedTile).toList(),
                    )
                  : ReorderableListView(
                      onReorder: _onReorder,
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      children: tasks.map(buildListTile).toList(),
                    ),
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createNewTask().then((item) {
            updateTasks();
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
    _locationSubscription?.cancel();
    super.dispose();
  }
}

typedef TimeCallback = Future<Task> Function();
