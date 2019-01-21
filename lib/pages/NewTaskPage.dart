import 'dart:async';
import 'dart:convert';

import 'package:cerf_mobile/components/TaskWindowPicker.dart';
import 'package:cerf_mobile/constants/secret.dart';
import 'package:cerf_mobile/services/tasks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cerf_mobile/model/Task.dart';

import 'package:http/http.dart' as http;

enum DialogAction {
  accept,
  cancel,
}

class NewTaskPage extends StatefulWidget {
  NewTaskPage({Key key}) : super(key: key);

  static const String routeName = '/newTask';

  @override
  _NewTaskPageState createState() => _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _submitting = false;

  final _hourController = TextEditingController(text: '0');
  final _minuteController = TextEditingController(text: '00');

  TimeOfDay startTime = TimeOfDay(hour: 9, minute: 0);
  TimeOfDay endTime = TimeOfDay(hour: 17, minute: 0);
  DateTime now = DateTime.now();

  Task task = Task(
    province: "ON",
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    task = Task(
      province: "ON",
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(value)));
  }

  bool _autovalidate = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String formatCity(String s) => s[0].toUpperCase() + s.substring(1);

  String _validateAddress(String value) {
    value = value.trim();
    if (value.isEmpty) return 'Address is required.';
    return null;
  }

  String _validateCity(String value) {
    value = value.trim();
    if (value.isEmpty) return 'City is required.';
    final RegExp nameExp = RegExp(
        r"^([a-zA-Z\u0080-\u024F]+(?:. |-| |'))*[a-zA-Z\u0080-\u024F]*$");
    if (!nameExp.hasMatch(value))
      return 'Please enter only alphabetical characters.';
    return null;
  }

  // String _validateProvince(String value) {
  //   value = value.trim();
  //   if (value.isEmpty) return 'Required.';
  //   final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
  //   if (!nameExp.hasMatch(value)) return 'A-Z only';
  //   return null;
  // }

  void _handleSubmitted() async {
    final FormState form = _formKey.currentState;
    setState(() {
      _submitting = true;
    });

    if (!form.validate()) {
      showInSnackBar('Please fix the errors in red before submitting.');
      setState(() {
        _submitting = false;
      });
    } else {
      form.save();
      if (!task.isAllDay) {
        task.windowStart = DateTime.utc(
            now.year, now.month, now.day, startTime?.hour, startTime?.minute);
        task.windowEnd = DateTime.utc(
            now.year, now.month, now.day, endTime?.hour, endTime?.minute);
      } else {
        task.windowStart =
            DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);
        task.windowEnd =
            DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);
      }
      final uri = Uri(
        scheme: "https",
        host: "maps.googleapis.com",
        path: "/maps/api/geocode/json",
        queryParameters: {
          "address": task.address + ", ${task.city}, ${task.province}",
          "key": Secret.gMapsAPI,
          "location_type": "RANGE_INTERPOLATED|ROOFTOP"
        },
      );
      http.get(uri.toString()).then((res) {
        if (res.statusCode == 200) {
          Map<String, dynamic> jsonRes = json.decode(res.body);
          Map<String, dynamic> location;
          try {
            List<dynamic> results = jsonRes["results"];
            // Handle if there are multiple results
            // print("${results.length} result(s) for query");
            var type = results[0]["geometry"]["location_type"];
            if (type == "ROOFTOP" || type == "RANGE_INTERPOLATED") {
              String addressResult = "";
              results[0]["address_components"].forEach((component) {
                addressResult = "$addressResult${component["short_name"]} ";
              });
              showDemoDialog<DialogAction>(
                context: context,
                child: AlertDialog(
                  title: Text('Is this the correct address?'),
                  content: Text("$addressResult"),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context, DialogAction.cancel);
                        }),
                    FlatButton(
                        child: Text('ACCEPT'),
                        onPressed: () {
                          Navigator.pop(context, DialogAction.accept);
                        })
                  ],
                ),
              ).then((value) {
                if (value == DialogAction.accept) {
                  location = results[0]["geometry"]["location"];
                  task.lat = location["lat"];
                  task.lng = location["lng"];
                  createTask(task).then((res) {
                    Navigator.of(context).pop(res);
                  });
                }
                setState(() {
                  _submitting = false;
                });
              });
            } else {
              showInSnackBar("No address found for ${task.address}");
              setState(() {
                _submitting = false;
              });
            }
          } catch (e) {
            showInSnackBar(
                "Error in locating address, please enter a valid address");
            print(e);
            setState(() {
              _submitting = false;
            });
          }
        } else {
          // Status code was not successfull
          showInSnackBar("Invalid request, please try again later");
          setState(() {
            _submitting = false;
          });
        }
      });
    }
  }

  Future<DialogAction> showDemoDialog<DialogAction>(
      {BuildContext context, Widget child}) async {
    return showDialog<DialogAction>(
      context: context,
      builder: (BuildContext context) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('New Task'),
        backgroundColor: isDark ? Colors.grey[900] : null,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 24.0),
                TextFormField(
                  key: Key('address'),
                  initialValue: "176 St George St", // ! remove
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                  onSaved: (String value) {
                    task.address = value.trim();
                  },
                  validator: _validateAddress,
                  maxLines: 1,
                ),
                SizedBox(height: 24.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        key: Key('city'),
                        initialValue: "London", // ! remove
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'City',
                        ),
                        onSaved: (String value) {
                          task.city = formatCity(value.trim());
                        },
                        validator: _validateCity,
                        maxLines: 1,
                      ),
                      flex: 2,
                    ),
                    SizedBox(width: 32.0),
                    Center(
                      child: DropdownButton<String>(
                        isDense: true,
                        items: <String>[
                          'ON',
                          'MB',
                          'SK',
                          'AB',
                          'NL',
                          'PE',
                          'NS',
                          'NB',
                          'QC',
                          'BC',
                          'YK',
                          'NT',
                          'NU'
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        value: task.province,
                        onChanged: (value) {
                          setState(() {
                            task.province = value;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16.0),
                    // Expanded(
                    //   child: TextFormField(
                    //     decoration:  InputDecoration(
                    //       border: OutlineInputBorder(),
                    //       labelText: 'Province',
                    //     ),
                    //     onSaved: (String value) {
                    //       task.province = value.trim();
                    //     },
                    //     validator: _validateProvince,
                    //     maxLines: 1,
                    //   ),
                    //   flex: 1,
                    // ),
                  ],
                ),
                SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("All day"),
                    Switch(
                        key: Key('all_day'),
                        value: task.isAllDay,
                        onChanged: (bool value) {
                          setState(() {
                            task.isAllDay = value;
                          });
                        }),
                  ],
                ),
                task.isAllDay ? Container() : windowComponents(context),
                SizedBox(height: 24.0),
                Text(
                  "Duration",
                  textAlign: TextAlign.center,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.remove_circle),
                      iconSize: 24.0,
                      onPressed: () {
                        int minuteVal = int.tryParse(_minuteController.text);
                        if (minuteVal != null && minuteVal >= 15) {
                          _minuteController.text = (minuteVal - 15).toString();
                        } else {
                          int hourVal = int.tryParse(_hourController.text);
                          if (hourVal != null && hourVal > 0) {
                            _hourController.text = (hourVal - 1).toString();
                            _minuteController.text =
                                ((minuteVal - 15) % 60).toString();
                          } else {
                            _minuteController.text = 0.toString();
                          }
                        }
                      },
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: TextFormField(
                            key: Key('hour'),
                            textAlign: TextAlign.center,
                            controller: _hourController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (String value) {
                              int numVal = int.tryParse(value);
                              if (numVal != null) {
                                task.duration += numVal * 60;
                              }
                            },
                          ),
                        ),
                        Text(":"),
                        Container(
                          width: 50.0,
                          child: TextFormField(
                            key: Key('minute'),
                            textAlign: TextAlign.center,
                            controller: _minuteController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly,
                            ],
                            onSaved: (String value) {
                              int numVal = int.tryParse(value);
                              if (numVal != null) {
                                task.duration += numVal;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle),
                      iconSize: 24.0,
                      onPressed: () {
                        int minuteVal = int.tryParse(_minuteController.text);
                        minuteVal += 15;
                        if (minuteVal != null && minuteVal < 60) {
                          _minuteController.text = (minuteVal).toString();
                        } else if (minuteVal >= 60) {
                          int hourIncrement = (minuteVal / 60).floor();
                          minuteVal -= hourIncrement * 60;
                          int hourVal = int.tryParse(_hourController.text);
                          if (hourVal != null) {
                            _hourController.text =
                                (hourVal + hourIncrement).toString();
                          } else {
                            _hourController.text = (hourIncrement).toString();
                          }
                          _minuteController.text = (minuteVal).toString();
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Notes about task',
                    labelText: 'Notes',
                  ),
                  onSaved: (String value) {
                    task.notes = value;
                  },
                  maxLines: 3,
                ),
                SizedBox(height: 24.0),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton.icon(
                        key: Key('createTaskButton'),
                        icon: Icon(Icons.add, size: 18.0),
                        label: Text('CREATE TASK'),
                        color: Theme.of(context).primaryColor,
                        onPressed: _submitting ? null : _handleSubmitted,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: startTime);
    if (picked != null && picked != startTime) {
      // refresh data
      setState(() {
        startTime = picked;
      });
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: endTime);
    if (picked != null && picked != endTime) {
      // refresh data
      setState(() {
        endTime = picked;
      });
    }
  }

  Widget windowComponents(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 24.0),
        Text("This task can be started between:"),
        SizedBox(height: 12.0),
        TaskWindowPicker(
          windowStart: startTime,
          windowEnd: endTime,
          selectStartTime: _selectStartTime,
          selectEndTime: _selectEndTime,
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _hourController.dispose();
    _minuteController.dispose();
    super.dispose();
  }
}
