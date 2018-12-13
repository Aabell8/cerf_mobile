// import 'package:cerf/constants/secret.dart';
import 'package:flutter/material.dart';
// import 'package:map_view/map_view.dart';
import 'package:cerf_mobile/model/Task.dart';
import 'package:cerf_mobile/pages/SchedulePage.dart';
import 'package:cerf_mobile/pages/NewTaskPage.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'dart:async';

void main() {
  // MapView.setApiKey(Strings.gMapsAPI);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cerf',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: AppColors.greenBlue,
        accentColor: AppColors.blueAccent,
        buttonColor: AppColors.greenBlue,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        // primaryColorBrightness: Brightness.dark,
        secondaryHeaderColor: AppColors.greenBlue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Task> _tasks = <Task>[];
  bool _started = false;

  @override
  void initState() {
    super.initState();
    _tasks = testTasks.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: Material(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          print("clicked Optimize");
                        },
                        child: Container(
                          height: 48.0,
                          child: Center(
                            child: Text(
                              "Optimize",
                              style: TextStyle(
                                color: Colors.purpleAccent[700],
                              ),
                            ),
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          // _started = true;
                          print("clicked Start");
                        },
                        child: Container(
                          height: 48.0,
                          child: Center(
                            child: Text(
                              "Start",
                              style: TextStyle(
                                color: Colors.greenAccent[700],
                              ),
                            ),
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SchedulePage(
        createNewTask: _createNewTask,
        tasks: _tasks,
        isStarted: _started,
      ),
    );
  }

  Future<Task> _createNewTask() async {
    return await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => NewTaskPage()));
  }
}
