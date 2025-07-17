import 'user.dart';

class Vehicle {
  final String id;
  final String make;
  final String model;
  final int? year;
  final String? color;
  final String plateNumber;
  final String vehicleType;
  final String ownerId;
  final DateTime? registrationDate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? owner;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    this.year,
    this.color,
    required this.plateNumber,
    required this.vehicleType,
    required this.ownerId,
    this.registrationDate,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.owner,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json["id"],
      make: json["make"],
      model: json["model"],
      year: json["year"],
      color: json["color"],
      plateNumber: json["plateNumber"],
      vehicleType: json["vehicleType"],
      ownerId: json["ownerId"],
      registrationDate: json["registrationDate"] != null
          ? DateTime.parse(json["registrationDate"])
          : null,
      isActive: json["isActive"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      owner: json["owner"] != null ? User.fromJson(json["owner"]) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "make": make,
      "model": model,
      "year": year,
      "color": color,
      "plateNumber": plateNumber,
      "vehicleType": vehicleType,
      "ownerId": ownerId,
      "registrationDate": registrationDate?.toIso8601String(),
      "isActive": isActive,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
      "owner": owner?.toJson(),
    };
  }
}
