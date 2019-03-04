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
    }
  }
"""
    .replaceAll("\n", ' ');
