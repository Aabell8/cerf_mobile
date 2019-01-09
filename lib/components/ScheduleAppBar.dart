import 'package:cerf_mobile/constants/colors.dart';
import 'package:flutter/material.dart';

class ScheduleAppBar extends PreferredSize {
  ScheduleAppBar({
    Key key,
    bool dark,
    bool isStarted = false,
    VoidCallback onStart,
    VoidCallback onOptimize,
    VoidCallback onPause,
  }) : super(
          preferredSize: Size.fromHeight(48.0),
          child: Material(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          print("clicked left button");
                        },
                        child: Container(
                          height: 48.0,
                          child: Center(
                            child: isStarted
                                ? Text(
                                    "Notify",
                                    style: TextStyle(
                                      color: AppColors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  )
                                : Text(
                                    "Optimize",
                                    style: TextStyle(
                                      color: AppColors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                    color: dark ? Colors.grey[850] : Colors.white,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Material(
                      child: InkWell(
                        onTap: () {
                          if (isStarted) {
                            onPause();
                          } else {
                            onStart();
                          }
                        },
                        child: Container(
                          height: 48.0,
                          child: Center(
                            child: isStarted
                                ? Text(
                                    "Pause",
                                    style: TextStyle(
                                      color: Colors.orangeAccent,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  )
                                : Text(
                                    "Start",
                                    style: TextStyle(
                                      color: AppColors.greenBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                    color: dark ? Colors.grey[850] : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
}
