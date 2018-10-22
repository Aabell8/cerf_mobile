import 'package:cerf_mobile/pages/TaskDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cerf_mobile/model/Task.dart';

class TaskListItem extends ListTile {
  TaskListItem(Task item, BuildContext context)
      : super(
          key: new Key(item.id),
          isThreeLine: true,
          title: new Text(
            '${item.address}',
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: new Text(
            '${item.duration} minutes ${Task.timeOfDayFormat(item.windowStart, item.windowEnd, item.isAllDay)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (BuildContext context) => new TaskDetailsPage(task: item),
              ),
            );
          },
        );
}

