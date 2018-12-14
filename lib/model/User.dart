class User {
  String id;
  String email;
  String username;
  String name;
  String password;

  User({
    this.id,
    this.email,
    this.username,
    this.name,
    this.password,
  });

  User copyWith({
    id,
    email,
    username,
    name,
    password,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      name: name ?? this.name,
      password: password ?? this.password,
    );
  }

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'],
        username = json['username'],
        name = json['name'],
        password = json['password'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'name': name,
        'password': password,
      };
}
