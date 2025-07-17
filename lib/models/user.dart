class User {
  final String id;
  final String name;
  final String nationalId;
  final String email;
  final String? phoneNumber;
  final String userType;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.nationalId,
    required this.email,
    this.phoneNumber,
    required this.userType,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      nationalId: json["nationalId"],
      email: json["email"],
      phoneNumber: json["phoneNumber"],
      userType: json["userType"],
      isActive: json["isActive"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "nationalId": nationalId,
      "email": email,
      "phoneNumber": phoneNumber,
      "userType": userType,
      "isActive": isActive,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }
}


