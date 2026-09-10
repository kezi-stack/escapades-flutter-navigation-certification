class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.country,
    required this.category,
    required this.description,
    required this.duration,
    required this.price,
    required this.rating,
    required this.imageUrl,
    required this.accent,
    required this.highlights,
  });

  final String id;
  final String name;
  final String country;
  final String category;
  final String description;
  final String duration;
  final double price;
  final double rating;
  final String imageUrl;
  final String accent;
  final List<String> highlights;

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      duration: json['duration'] as String,
      price: (json['price'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      accent: json['accent'] as String,
      highlights: (json['highlights'] as List<dynamic>).cast<String>(),
    );
  }
}