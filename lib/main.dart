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
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Cerf',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        // brightness: Brightness.dark,
        primarySwatch: AppColors.greenBlue,
        accentColor: AppColors.blueAccent,
        buttonColor: AppColors.greenBlue,
        buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
        // primaryColorBrightness: Brightness.dark,
        secondaryHeaderColor: AppColors.greenBlue,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule"),
        bottom: new PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: new Material(
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: new Container(
                    child: new Material(
                      child: new InkWell(
                        onTap: () {
                          print("clicked Optimize");
                        },
                        child: new Container(
                          height: 48.0,
                          child: new Center(
                            child: new Text(
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
                new Expanded(
                  child: new Container(
                    child: new Material(
                      child: new InkWell(
                        onTap: () {
                          print("clicked Start");
                        },
                        child: new Container(
                          height: 48.0,
                          child: new Center(
                            child: new Text(
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
      body: new SchedulePage(
        createNewTask: _createNewTask,
      ),
    );
  }

  Future<Task> _createNewTask() async {
    return await Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new NewTaskPage()));
  }
}
