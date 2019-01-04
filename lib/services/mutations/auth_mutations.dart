String login = """
  mutation(\$email: String!, \$password: String!) {
    login(email: \$email, password: \$password) {
      id
      email
      name
      username
      isStarted
    }
  }
"""
    .replaceAll('\n', ' ');

String signUp = """
  mutation(\$email: String!, \$password: String!) {
    signUp(email: \$email, password: \$password) {
      id,
      email,
      name,
      username,
      isStarted
    }
  }
""".replaceAll('\n', ' ');

String logout = """
  mutation {
    logout
  }
""".replaceAll('\n', ' ');