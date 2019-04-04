import 'dart:async';

import 'package:cerf_mobile/components/ScheduleAppBar.dart';
import 'package:cerf_mobile/components/settings/VissOptions.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/pages/NewTaskPage.dart';
import 'package:cerf_mobile/pages/SettingsPage.dart';
import 'package:cerf_mobile/services/tasks.dart';
import 'package:cerf_mobile/services/user.dart';
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
  TextEditingController _dialogController;
  ScrollController _scrollController;

  bool _reordered;
  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = Location();

  void initState() {
    super.initState();
    _isStarted = false;
    _isLoading = true;
    _reordered = false;
    _dialogController = TextEditingController();
    _scrollController = ScrollController();
    updateTasks();
  }

  Widget buildListTile(Task item) {
    return TaskListItem(item, context, updateStatus);
  }

  Widget buildExpandedTile(Task item) {
    return ExpandableTaskListItem(
        item, context, _currentTask == item.id, updateStatus);
  }

  Future<void> updateTasks() {
    setState(() {
      _isLoading = true;
    });
    return fetchTasks().then<void>((res) {
      setState(() {
        tasks = res;
        // Set isStarted to false here if problem
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

  void animateToCurrentTask(bool initial) {
    int i = tasks.indexWhere((task) => task.id == _currentTask);
    // Not dynamically set and based on default size
    double itemSize = 98.0;
    if (initial) {
      _scrollController = ScrollController(initialScrollOffset: i * itemSize);
      return;
    }
    if (_isStarted) {
      _scrollController.animateTo(
        i * itemSize,
        duration: Duration(seconds: 1),
        curve: Curves.ease,
      );
    }
  }

  void updateStatus(Task task) async {
    // If update notes on task status changed
    if (task.status != "a" && widget.options.updateNotes) {
      _dialogController.text = task.notes;
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Update Notes"),
              content: TextField(
                decoration: new InputDecoration(
                  hintText: "Enter updated notes for task",
                  border: OutlineInputBorder(),
                ),
                controller: _dialogController,
                maxLines: 8,
              ),
              actions: <Widget>[
                FlatButton(
                    child: Text('SAVE'),
                    onPressed: () {
                      task.notes = _dialogController.text;
                      Navigator.of(context).pop();
                    }),
              ],
            ),
      );
    }

    // Update status on server
    updateTaskStatus(task).catchError((err) {
      showSnackBarMessage("Error in updating task status.\nError code: $err");
    });
    getNextTask();
    animateToCurrentTask(false);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Task item = tasks.removeAt(oldIndex);
      tasks.insert(newIndex, item);
      _reordered = true;
    });
  }

  Future<void> initPlatformState() async {
    Map<String, double> location;
    try {
      bool permission = await _location.hasPermission();
      if (permission) {
        // ? Error in starting on iOS, this function doesnt return
        location = await _location.getLocation();
      }
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

    _currentLocation = location;

    return;
  }

  void onStarted() async {
    // Changed to be async but check for location in function
    await initPlatformState();
    if (!getNextTask()) {
      showSnackBarMessage("No tasks remaining to be completed today");
      return;
    }
    animateToCurrentTask(true);

    if (_reordered) {
      // Update task order in database
      updateTaskOrder(tasks);
      _reordered = false;
    }

    Map<String, dynamic> variables = {"isStarted": true};

    if (_currentLocation != null) {
      variables["lat"] = _currentLocation["latitude"];
      variables["lng"] = _currentLocation["longitude"];
    }

    try {
      await updateUser(variables);
    } catch (err) {
      showSnackBarMessage("Error in starting, code: $err");
      return;
    }

    setState(() {
      _locationSubscription =
          _location.onLocationChanged().listen((Map<String, double> result) {
        _currentLocation = result;
      });

      // ? Create timer to send updated location to server every x seconds
      // Filter tasks
      // tasksTodo = filterTodo();
      // _currentTask = tasksTodo.isNotEmpty ? tasksTodo[0]?.id : "";
      _isStarted = true;
    });
  }

  void onPaused() async {
    try {
      await updateUser({"isStarted": false});
    } catch (err) {
      showSnackBarMessage("Status failed to update, code: $err");
    }
    setState(() {
      _locationSubscription.cancel();
      _isStarted = false;
    });
  }

  void onOptimize() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });
    optimizeTasks(tasks).then<void>((res) {
      setState(() {
        tasks = res;
        _reordered = true;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _isLoading = false;
      });
      showSnackBarMessage("Error in optimizing tasks - \nError code: $e");
    });

    return;
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
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: updateTasks,
          )
        ],
        bottom: ScheduleAppBar(
          dark: isDark,
          isStarted: _isStarted,
          onStart: onStarted,
          onPause: onPaused,
          onOptimize: onOptimize,
        ),
      ),
      body: !_isLoading
          ? Scrollbar(
              child: Container(
                child: _isStarted
                    ? ListView(
                        scrollDirection: Axis.vertical,
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        children: tasks.map(buildExpandedTile).toList(),
                      )
                    : ReorderableListView(
                        onReorder: _onReorder,
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        children: tasks.map(buildListTile).toList(),
                      ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
      floatingActionButton: !_isStarted
          ? FloatingActionButton(
              onPressed: () {
                _createNewTask().then((item) {
                  updateTasks();
                });
              },
              child: Icon(Icons.add),
              backgroundColor:
                  isDark ? AppColors.greenBlue : AppColors.blueAccent,
            )
          : null,
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
