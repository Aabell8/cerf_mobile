import 'dart:async';
import 'dart:convert';

import 'package:cerf_mobile/components/TaskWindowPicker.dart';
import 'package:cerf_mobile/constants/secret.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cerf_mobile/model/Task.dart';

// import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;

import 'dart:math';

enum DialogAction {
  accept,
  cancel,
}

class NewTaskPage extends StatefulWidget {
  const NewTaskPage({Key key}) : super(key: key);

  static const String routeName = '/newTask';

  @override
  _NewTaskPageState createState() => new _NewTaskPageState();
}

class _NewTaskPageState extends State<NewTaskPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _submitting = false;

  final _hourController = TextEditingController(text: '0');
  final _minuteController = TextEditingController(text: '00');

  Task task = new Task(
    windowStart: new TimeOfDay(hour: 9, minute: 0),
    windowEnd: new TimeOfDay(hour: 17, minute: 0),
    province: "ON",
  );

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  bool _autovalidate = false;

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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

  void _handleSubmitted() {
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
      final uri = new Uri(
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
            print("${results.length} result for query");
            var type = results[0]["geometry"]["location_type"];
            if (type == "ROOFTOP" || type == "RANGE_INTERPOLATED") {
              String addressResult = "";
              results[0]["address_components"].forEach((component) {
                print(component);
                addressResult = "$addressResult${component["short_name"]} ";
              });
              showDemoDialog<DialogAction>(
                context: context,
                child: AlertDialog(
                  title: const Text('Is this the correct address?'),
                  content: Text("$addressResult"),
                  actions: <Widget>[
                    FlatButton(
                        child: const Text('CANCEL'),
                        onPressed: () {
                          Navigator.pop(context, DialogAction.cancel);
                        }),
                    FlatButton(
                        child: const Text('ACCEPT'),
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
                  task.id = new Random().nextInt(10000).toString();
                  Navigator.of(context).pop(task);
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('New Task'),
      ),
      body: new SafeArea(
        top: false,
        bottom: false,
        child: new Form(
          key: _formKey,
          autovalidate: _autovalidate,
          child: new SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 24.0),
                new TextFormField(
                  key: new Key('address'),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                  onSaved: (String value) {
                    task.address = value.trim();
                  },
                  validator: _validateAddress,
                  maxLines: 1,
                ),
                const SizedBox(height: 24.0),
                Row(
                  children: <Widget>[
                    new Expanded(
                      child: new TextFormField(
                        key: new Key('city'),
                        decoration: const InputDecoration(
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
                    const SizedBox(width: 32.0),
                    Center(
                      child: new DropdownButton<String>(
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
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
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
                    const SizedBox(width: 16.0),
                    // new Expanded(
                    //   child: new TextFormField(
                    //     decoration: const InputDecoration(
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
                const SizedBox(height: 24.0),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text("All day"),
                    new Switch(
                        key: new Key('all_day'),
                        value: task.isAllDay,
                        onChanged: (bool value) {
                          setState(() {
                            task.isAllDay = value;
                          });
                        }),
                  ],
                ),
                task.isAllDay ? new Container() : windowComponents(context),
                const SizedBox(height: 24.0),
                new Text(
                  "Duration",
                  textAlign: TextAlign.center,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    new IconButton(
                      icon: new Icon(Icons.remove_circle),
                      iconSize: 24.0,
                      onPressed: () {},
                    ),
                    new Row(
                      children: <Widget>[
                        new Container(
                          width: 50.0,
                          child: new TextFormField(
                            key: new Key('hour'),
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
                        new Text(":"),
                        new Container(
                          width: 50.0,
                          child: new TextFormField(
                            key: new Key('minute'),
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
                    new IconButton(
                      icon: new Icon(Icons.add_circle),
                      iconSize: 24.0,
                      onPressed: () {
                        int minuteVal = int.tryParse(_minuteController.text);
                        if (minuteVal != null && minuteVal < 59) {
                          _minuteController.text = (minuteVal + 1).toString();
                        } else {
                          _minuteController.text = (minuteVal - 59).toString();
                          int hourVal = int.tryParse(_hourController.text);
                          if (hourVal != null) {
                            _hourController.text = (hourVal + 1).toString();
                          }
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24.0),
                new TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Notes about task',
                    labelText: 'Notes',
                  ),
                  onSaved: (String value) {
                    task.notes = value;
                  },
                  maxLines: 3,
                ),
                const SizedBox(height: 24.0),
                new Row(
                  children: <Widget>[
                    new Expanded(
                      child: new RaisedButton.icon(
                        key: new Key('createTaskButton'),
                        icon: const Icon(Icons.add, size: 18.0),
                        label: const Text('CREATE TASK'),
                        color: Theme.of(context).primaryColor,
                        onPressed: _submitting ? null : _handleSubmitted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Null> _selectStartTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: task.windowStart);
    if (picked != null && picked != task.windowStart) {
      task.windowStart = picked;
      // refresh data
      setState(() {});
    }
  }

  Future<Null> _selectEndTime(BuildContext context) async {
    final TimeOfDay picked =
        await showTimePicker(context: context, initialTime: task.windowEnd);
    if (picked != null && picked != task.windowEnd) {
      task.windowEnd = picked;
      // refresh data
      setState(() {});
    }
  }

  Widget windowComponents(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 24.0),
        new Text("This task can be started between:"),
        const SizedBox(height: 12.0),
        new TaskWindowPicker(
          windowStart: task.windowStart,
          windowEnd: task.windowEnd,
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
