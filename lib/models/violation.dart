import 'user.dart';
import 'vehicle.dart';

class Violation {
  final String id;
  final String type;
  final String? description;
  final String location;
  final DateTime timestamp;
  final double fineAmount;
  final String status;
  final bool isPaid;
  final DateTime? paymentDate;
  final String vehicleId;
  final String officerId;
  final String? evidenceImageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Vehicle? vehicle;
  final User? officer;

  Violation({
    required this.id,
    required this.type,
    this.description,
    required this.location,
    required this.timestamp,
    required this.fineAmount,
    required this.status,
    required this.isPaid,
    this.paymentDate,
    required this.vehicleId,
    required this.officerId,
    this.evidenceImageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.vehicle,
    this.officer,
  });

  factory Violation.fromJson(Map<String, dynamic> json) {
    return Violation(
      id: json['id'],
      type: json['type'],
      description: json['description'],
      location: json['location'],
      timestamp: DateTime.parse(json['timestamp']),
      fineAmount: json['fineAmount'].toDouble(),
      status: json['status'],
      isPaid: json['isPaid'],
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'])
          : null,
      vehicleId: json['vehicleId'],
      officerId: json['officerId'],
      evidenceImageUrl: json['evidenceImageUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      vehicle:
          json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null,
      officer: json['officer'] != null ? User.fromJson(json['officer']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'description': description,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'fineAmount': fineAmount,
      'status': status,
      'isPaid': isPaid,
      'paymentDate': paymentDate?.toIso8601String(),
      'vehicleId': vehicleId,
      'officerId': officerId,
      'evidenceImageUrl': evidenceImageUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'vehicle': vehicle?.toJson(),
      'officer': officer?.toJson(),
    };
  }
}
