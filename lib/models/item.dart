class Items {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;

  Items({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory Items.fromFirestore(Map<String, dynamic> firestore) {
    return Items(
      id: firestore['id'] as String,
      name: firestore['name'] as String,
      price: (firestore['price'] as num).toDouble(),
      description: firestore['description'] as String,
      imageUrl: firestore['imageUrl'] as String,
    );
  }
}
