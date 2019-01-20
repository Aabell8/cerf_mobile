String currentUserTasks = """
  {
    myTasks {
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
