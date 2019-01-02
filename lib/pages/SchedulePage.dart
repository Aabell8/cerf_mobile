import 'dart:async';

import 'package:cerf_mobile/components/ScheduleAppBar.dart';
import 'package:cerf_mobile/components/settings/VissOptions.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/pages/NewTaskPage.dart';
import 'package:cerf_mobile/pages/SettingsPage.dart';
import 'package:cerf_mobile/services/auth.dart';
import 'package:cerf_mobile/services/auth_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/components/TaskListItem.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage(
      {Key key,
      this.isStarted = false,
      this.options,
      this.onSignedOut,
      this.onOptionsChanged})
      : super(key: key);

  final bool isStarted;
  final VissOptions options;
  final ValueChanged<VissOptions> onOptionsChanged;
  final VoidCallback onSignedOut;

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey<ScaffoldState>();

  List<Task> tasks = testTasks.toList();

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

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
          title: Text("Schedule"),
          backgroundColor: isDark ? Colors.grey[900] : null,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () => _goToSettings(),
            )
            // PopupMenuButton<String>(
            //   onSelected: (String s) => _select(s, context),
            //   itemBuilder: (BuildContext context) {
            //     return ["logout", "dark"].map((String choice) {
            //       return PopupMenuItem<String>(
            //         value: choice,
            //         child: Text(choice),
            //       );
            //     }).toList();
            //   },
            // ),
          ],
          bottom: ScheduleAppBar(dark: isDark)),
      body: Scrollbar(
        child: widget.isStarted
            ? Column(
                children: <Widget>[
                  Text("Test column"),
                  ListView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: tasks.map(buildListTile).toList(),
                  )
                ],
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

  // void _select(String choice, BuildContext context) async {
  //   if (choice == 'logout') {
  //     try {
  //       Auth auth = AuthProvider.of(context).auth;
  //       await auth.logout();
  //       widget.onSignedOut();
  //     } catch (e) {
  //       print(e);
  //     }
  //   } else if (choice == 'dark') {
  //     widget.onThemeChanged();
  //   }
  // }

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
}

typedef TimeCallback = Future<Task> Function();
