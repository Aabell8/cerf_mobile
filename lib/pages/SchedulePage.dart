// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cerf_mobile/components/ScheduleAppBar.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/pages/NewTaskPage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/components/TaskListItem.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key key, this.isStarted = false}) : super(key: key);

  final bool isStarted;

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
    // print(widget.tasks.length);
    return Scaffold(
      appBar: ScheduleAppBar(),
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
              print("Added item");
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.blueAccent,
      ),
    );
  }

  Future<Task> _createNewTask() async {
    return await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => NewTaskPage()));
  }
}

typedef TimeCallback = Future<Task> Function();
