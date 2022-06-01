class User {
  const User(this.name);
  final String name;
  static User fromJSON(Map<String, dynamic> json) {
    return User(json["name"]);
  }
}
