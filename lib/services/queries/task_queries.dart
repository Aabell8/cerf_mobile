String currentUserTasks = """
  query(\$timeZone: Int) {
    myTasks(timeZone: \$timeZone) {
      id
      name
      order
      status
      address
      city
      province
      lat
      lng
      windowStart
      windowEnd
      duration
      isAllDay
      notes
      email
      phone
    }
  }
"""
    .replaceAll("\n", ' ');

String optimizeTasks = """
  query(\$ids: [ID!]!) {
    optimizedTasks(ids: \$ids) {
      id
      name
      order
      status
      address
      city
      province
      lat
      lng
      windowStart
      windowEnd
      duration
      isAllDay
      notes
      email
      phone
    }
  }
"""
    .replaceAll("\n", ' ');
