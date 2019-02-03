String currentUserTasks = """
  query(\$timeZone: Int) {
    myTasks(timeZone: \$timeZone) {
      id
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
