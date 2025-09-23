
class Plant {
  final String id;
  final String name;
  final String category;
  final String? imagePath;
  final DateTime createdAt;

  Plant({
    required this.id,
    required this.name,
    required this.category,
    this.imagePath,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}
