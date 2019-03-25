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
  mutation(\$name: String, \$email: String!, \$password: String!) {
    signUp(name: \$name, email: \$email, password: \$password) {
      id
      email
      name
      username
      isStarted
    }
  }
"""
    .replaceAll('\n', ' ');

String logout = """
  mutation {
    logout
  }
"""
    .replaceAll('\n', ' ');
