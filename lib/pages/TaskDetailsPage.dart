import 'package:cerf_mobile/components/DetailsCategory.dart';
import 'package:cerf_mobile/components/DetailsButton.dart';
import 'package:cerf_mobile/components/DetailsItem.dart';
import 'package:cerf_mobile/constants/secret.dart';
import 'package:cerf_mobile/model/Task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({this.task});

  final Task task;

  @override
  TaskDetailsPageState createState() => TaskDetailsPageState();
}

class TaskDetailsPageState extends State<TaskDetailsPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;

  Uri staticMapUri;

  @override
  initState() {
    super.initState();
    double lat = 43.006047;
    double lng = -81.260782;
    if (widget.task.lat != null && widget.task.lng != null) {
      lat = widget.task.lat;
      lng = widget.task.lng;
    }
    staticMapUri = Uri(
        scheme: "https",
        host: "maps.googleapis.com",
        path: "/maps/api/staticmap",
        queryParameters: {
          // Offsets slightly low because of gradient
          "center": "${lat + 0.0003},$lng",
          "key": Secret.gMapsAPI,
          "size": "400x900", // May not want to be static
          "zoom": "17", // Static for now
          "markers": "size:mid|color:0x2CA579|label:T|$lat,$lng"
        });
  }

  @override
  Widget build(BuildContext context) {
    Task task = widget.task;
    // const double lat = task.lat;
    // lat = task.lat.toString();
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: _appBarHeight,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.create),
                tooltip: 'Edit',
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(const SnackBar(
                      content:
                          Text("Editing isn't supported in this screen.")));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              // title: const Text('Ali Connors'),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.network(
                    staticMapUri.toString(),
                    fit: BoxFit.cover,
                    height: _appBarHeight,
                  ),

                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.dark,
                child: DetailsCategory(
                  icon: Icons.location_on,
                  children: <Widget>[
                    DetailsItem(
                      icon: Icons.directions,
                      tooltip: 'Get Directions',
                      onPressed: () async {
                        Uri launchUri = Uri(
                            scheme: "https",
                            host: "www.google.com",
                            path: "/maps/search/",
                            queryParameters: {
                              "api": "1",
                              "query":
                                  "${task.address}, ${task.city}, ${task.province}"
                            });
                        String url = launchUri.toString();

                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      lines: <String>[
                        widget.task.address,
                        'Address',
                      ],
                    ),
                    DetailsItem(
                      tooltip: 'Get Directions',
                      lines: <String>[
                        "${task.duration} minutes, ${Task.timeOfDayFormat(task.windowStart, task.windowEnd, task.isAllDay)}",
                        'Estimated time: ',
                      ],
                    ),
                  ],
                ),
              ),
              widget.task.notes != ""
                  ? Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Theme.of(context).dividerColor))),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Text(widget.task.notes,
                            style: Theme.of(context).textTheme.caption),
                      ),
                    )
                  : Container(width: 0.0, height: 0.0),
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Theme.of(context).dividerColor))),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: <Widget>[
                      // TODO: reword this
                      Text("To share progress with the client:"),
                      Row(
                        children: <Widget>[
                          DetailsButton(
                            text: "Email",
                            icon: Icons.email,
                            onPressed: () {},
                          ),
                          DetailsButton(
                            text: "Copy Link",
                            icon: Icons.link,
                            onPressed: () {},
                          ),
                          DetailsButton(
                            text: "Other",
                            icon: Icons.more_horiz,
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
