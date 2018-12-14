import 'package:flutter/material.dart';

class ScheduleAppBar extends AppBar {
  ScheduleAppBar({Key key})
      : super(
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
        );
}
