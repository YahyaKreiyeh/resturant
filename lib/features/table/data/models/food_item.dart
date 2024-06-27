class FoodItem {
  final int id;
  final int categoryId;
  final String name;
  final double price;
  final String image;

  FoodItem({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.price,
    required this.image,
  });

  factory FoodItem.fromMap(Map<String, dynamic> map) {
    return FoodItem(
      id: map['id'],
      categoryId: map['category_id'],
      name: map['name'],
      price: map['price'],
      image: map['image'],
    );
  }
}
