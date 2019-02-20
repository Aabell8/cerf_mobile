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
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

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

  Map<String, double> _currentLocation;
  StreamSubscription<Map<String, double>> _locationSubscription;
  Location _location = Location();

  void initState() {
    super.initState();
    _isStarted = false;
    _isLoading = true;
    _dialogController = TextEditingController();
    updateTasks();
  }

  Future<void> updateTasks() {
    // setState(() {
    //   _isLoading = true;
    // });
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

    return;
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
  }

  Widget buildListTile(Task item) {
    return TaskListItem(item, context, updateStatus);
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
    // Changed to be async but check for location in function
    initPlatformState();
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

  onOptimize() {
    // ? Set up optimization of tasks
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
              child: LiquidPullToRefresh(
                color: AppColors.greenBlue,
                showChildOpacityTransition: true,
                springAnimationDurationInMilliseconds: 300,
                onRefresh: updateTasks,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          // ? This solution should not be final
                          // ? and setting height of content should not be hard
                          // ? coded. Works on all tested devices to work so far
                          Container(
                            height: MediaQuery.of(context).size.height - 130,
                            child: _isStarted
                                ? ListView(
                                    scrollDirection: Axis.vertical,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    children:
                                        tasks.map(buildExpandedTile).toList(),
                                  )
                                : ReorderableListView(
                                    onReorder: _onReorder,
                                    scrollDirection: Axis.vertical,
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    children: tasks.map(buildListTile).toList(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
        backgroundColor: isDark ? AppColors.greenBlue : AppColors.blueAccent,
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
