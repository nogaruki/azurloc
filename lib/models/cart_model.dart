import 'activity_model.dart';

class Cart {
  final String id;
  final String user;
  final List<Activity> activities; // IDs of activities

  Cart({required this.id, required this.user, required this.activities});

  factory Cart.fromJson(Map<String, dynamic> json, categories) {
    final cart = json['cart'];
    List<Activity> activitiesObjects = cart['activities'].map<Activity>((activity) => Activity.fromJson(activity, categories)).toList();
    return Cart(
      id: cart['_id'],
      user: cart['user'],
      activities:activitiesObjects,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'activities': activities,
    };
  }
}
