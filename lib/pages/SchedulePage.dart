// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:cerf_mobile/constants/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/components/TaskListItem.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage(
      {Key key, this.createNewTask, this.isStarted = false, this.tasks})
      : super(key: key);

  final TimeCallback createNewTask;
  final bool isStarted;
  final List<Task> tasks;

  @override
  _SchedulePageState createState() => new _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  Widget buildListTile(Task item) {
    return new TaskListItem(item, context);
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Task item = widget.tasks.removeAt(oldIndex);
      widget.tasks.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.tasks.length);
    return new Scaffold(
      body: new Scrollbar(
        child: widget.isStarted
            ? new Column(
                children: <Widget>[
                  Text("Test column"),
                  new ListView(
                    scrollDirection: Axis.vertical,
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    children: widget.tasks.map(buildListTile).toList(),
                  )
                ],
              )
            : new ReorderableListView(
                onReorder: _onReorder,
                scrollDirection: Axis.vertical,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                children: widget.tasks.map(buildListTile).toList(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.createNewTask().then((item) {
            if (item != null) {
              widget.tasks.add(item);
              print("Added item");
            }
          });
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.blueAccent,
      ),
    );
  }
}

typedef TimeCallback = Future<Task> Function();
