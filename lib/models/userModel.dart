class UserModel {
  final String userId;
  final String userName;
  final String password;
  final String timestamp;
  final bool isAdmin;
  final String email;

  UserModel({
    this.userId,
    this.password,
    this.userName,
    this.timestamp,
    this.email,
    this.isAdmin,
  });

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "userName": userName,
      "password": password,
      "timestamp": timestamp,
      "email": email,
      "isAdmin": isAdmin
    };
  }

  factory UserModel.fromMap(Map map) {
    return UserModel(
      userId: map["userId"],
      userName: map["userName"],
      password: map["password"],
      timestamp: map["timestamp"],
      email: map["email"],
      isAdmin: map["isAdmin"],
    );
  }

  factory UserModel.fromDocument(doc) {
    return UserModel(
      userId: doc.data()["userId"],
      password: doc.data()["password"],
      userName: doc.data()["userName"],
      timestamp: doc.data()["timestamp"],
      email: doc.data()["email"],
      isAdmin: doc.data()["isAdmin"],
    );
  }
}
