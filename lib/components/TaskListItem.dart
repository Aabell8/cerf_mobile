import 'package:cerf_mobile/pages/TaskDetailsPage.dart';
import 'package:flutter/material.dart';
import 'package:cerf_mobile/model/Task.dart';

class TaskListItem extends ListTile {
  TaskListItem(Task item, BuildContext context)
      : super(
          key: Key(item.id),
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
                builder: (BuildContext context) => TaskDetailsPage(task: item),
              ),
            );
          },
        );
}

