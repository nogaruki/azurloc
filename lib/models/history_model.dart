
import 'package:azurloc/models/activity_model.dart';

class History {
  final String id;
  final String user;
  final List<Activity> activities;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double total;

  History({required this.id, required this.user, required this.activities, required this.createdAt, required this.updatedAt, required this.total});

  factory History.fromJson(Map<String, dynamic> json, categories) {
    List<Activity> activitiesObjects = json['activities'].map<Activity>((activity) => Activity.fromJson(activity, categories)).toList();
    double total = double.tryParse(json['total'].toString()) ?? 0.0;
    return History(
      id: json['_id'],
      user: json['user'],
      activities: activitiesObjects,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      total: total,
    );
  }
}
