String updateUser = """
  mutation(\$name: String, \$email: String, 
       \$lat: Float, \$lng: Float, \$isStarted: Boolean) {
    updateUser(name: \$name, email: \$email, 
        lat: \$lat, lng: \$lng, isStarted: \$isStarted) {
      id
      email
      name
      username
      isStarted
    }
  }
"""
    .replaceAll('\n', ' ');
