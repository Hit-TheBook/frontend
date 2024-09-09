// lib/models/dday_model.dart
class DdayModel {
  final String? id; // Nullable
  final String ddayName;
  final DateTime startDate;
  final DateTime endDate;

  DdayModel({
    this.id, // Nullable
    required this.ddayName,
    required this.startDate,
    required this.endDate,
  });

  factory DdayModel.fromJson(Map<String, dynamic> json) {
    return DdayModel(
      id: json['id'] as String?,
      ddayName: json['ddayName'] as String,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ddayName': ddayName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
