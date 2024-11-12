
class Location {
  final int id;
  final String name;
  final String image;

  Location({
    required this.id,
    required this.name,
    required this.image,
  });

  // Factory constructor for creating a Location instance from JSON
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  // Method for converting a Location instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
