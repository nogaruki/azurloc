import 'package:azurloc/models/category_model.dart';

class Activity {
  final String id;
  String image;
  String title;
  String place;
  double price;
  String category;
  Category? categoryObject;
  int minPeople;
  String description;
  DateTime date;

  Activity({
    required this.id,
    required this.image,
    required this.title,
    required this.place,
    required this.price,
    required this.category,
    required this.minPeople,
    required this.description,
    required this.date,
    this.categoryObject,
  });

  factory Activity.fromJson(Map<String, dynamic> activity, List<Category> categories) {
    final category = categories.firstWhere((category) => category.id == activity['category']);
    return Activity(
      id: activity['_id'],
      image: activity['image'],
      title: activity['title'],
      place: activity['place'],
      price: activity['price'].toDouble(),
      category: activity['category'],
      categoryObject: category,
      minPeople: activity['minPeople'],
      description: activity['description'],
      date: DateTime.parse(activity['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': image,
      'title': title,
      'place': place,
      'price': price,
      'category': category,
      'minPeople': minPeople,
      'description': description,
      'date': date.toIso8601String(), // Convertit DateTime en String
    };
  }
}
