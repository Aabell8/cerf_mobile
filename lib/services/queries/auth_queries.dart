String currentUser = """
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
