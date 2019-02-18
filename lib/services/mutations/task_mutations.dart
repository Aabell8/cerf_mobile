String createTask = """
  mutation (\$address: String!, \$city: String!, \$province: String!, 
  \$lat: Float, \$lng: Float, \$isAllDay: Boolean, \$windowStart: String, 
  \$windowEnd: String, \$duration: Int!, \$notes: String) {
    createTask(address: \$address, city: \$city, province: \$province, 
    lat: \$lat, lng: \$lng, isAllDay: \$isAllDay, windowStart: \$windowStart, 
    windowEnd: \$windowEnd, duration: \$duration, notes: \$notes) {
      id
      address
      city
      province
      lat
      lng
      isAllDay
      windowStart
      windowEnd
      duration
      notes
      status
    }
  }
"""
    .replaceAll('\n', ' ');

String updateTaskStatus = """
  mutation(\$id: ID!, \$status: String) {
    updateTask (id: \$id, status: \$status) {
      id
      address
      city
      province
      lat
      lng
      isAllDay
      windowStart
      windowEnd
      duration
      notes
      status
    }
  }
"""
    .replaceAll('\n', ' ');
