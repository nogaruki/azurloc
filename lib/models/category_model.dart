class Category {
  final String id;
  String name;
  String description;
  List<String> activities; // IDs of activities
  final DateTime createdAt;
  final DateTime updatedAt;


  Category({required this.id, required this.name, required this.description, required this.activities, required this.createdAt, required this.updatedAt});

  factory Category.fromJson(Map<String, dynamic> category) {
    return Category(
      id: category['_id'],
      name: category['name'],
      description: category['description'],
      activities: List<String>.from(category['activities']),
      createdAt: DateTime.parse(category['createdAt']),
      updatedAt: DateTime.parse(category['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'activities': activities,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
