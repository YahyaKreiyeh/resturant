class FoodCategory {
  final int id;
  final String name;

  FoodCategory({required this.id, required this.name});

  factory FoodCategory.fromMap(Map<String, dynamic> map) {
    return FoodCategory(
      id: map['id'],
      name: map['name'],
    );
  }
}
