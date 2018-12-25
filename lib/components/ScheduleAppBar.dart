import 'package:cerf_mobile/constants/colors.dart';
import 'package:flutter/material.dart';

class ScheduleAppBar extends PreferredSize {
  ScheduleAppBar({Key key})
      : super(
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
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
}
