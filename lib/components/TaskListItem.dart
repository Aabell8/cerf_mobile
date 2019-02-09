import 'package:cerf_mobile/components/DetailsButton.dart';
import 'package:cerf_mobile/pages/TaskDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cerf_mobile/constants/colors.dart';
import 'package:cerf_mobile/model/Task.dart';
import 'package:url_launcher/url_launcher.dart';

Color getColor(String status) {
  // Finished status code
  if (status == "f") {
    return AppColors.greenBlue.withAlpha(50);
  }
  // Cancelled status code
  else if (status == "c") {
    return Colors.orangeAccent.withAlpha(50);
  }
  return null;
}

class TaskListItem extends Card {
  TaskListItem(Task item, BuildContext context)
      : super(
          key: Key(item.id),
          child: Container(
            child: ListTile(
              isThreeLine: true,
              title: Text(
                '${item.address}',
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                '${item.duration} minutes ${Task.timeOfDayFormat(item.windowStart, item.windowEnd, item.isAllDay)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TaskDetailsPage(task: item),
                  ),
                );
              },
            ),
            color: getColor(item.status)
          ),
        );
}

class ExpandableTaskListItem extends StatelessWidget {
  ExpandableTaskListItem(this.task, this.context, this.expanded);

  final Task task;
  final BuildContext context;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      key: Key(task.id),
      opacity: expanded ? 1.0 : 0.4,
      child: Card(
        child: Container(
          child: Column(
            children: <Widget>[
              ListTile(
                key: Key(task.id),
                title: Text(
                  '${task.address}',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  '${task.duration} minutes ${Task.timeOfDayFormat(task.windowStart, task.windowEnd, task.isAllDay)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                          TaskDetailsPage(task: task),
                    ),
                  );
                },
              ),
              Divider(height: 0.0),
              expanded
                  ? Row(
                      children: <Widget>[
                        DetailsButton(
                          text: "Cancel",
                          icon: Icons.close,
                          condensed: true,
                          onPressed: () {},
                        ),
                        DetailsButton(
                          text: "Directions",
                          icon: Icons.directions,
                          condensed: true,
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
                        ),
                        DetailsButton(
                          text: "Complete",
                          icon: Icons.check,
                          condensed: true,
                          onPressed: () {},
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: 8.0)
            ],
          ),
        ),
      ),
    );
  }
}
