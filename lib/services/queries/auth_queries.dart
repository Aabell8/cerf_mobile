String current_user = """
  {
    me {
      id
      email
      name
      username
      isStarted
    }
  }
"""
    .replaceAll('\n', ' ');
