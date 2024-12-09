class Membership {
  final String id;
  final String name;
  final String description;
  final double price;
  final int durationMonths;

  Membership({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMonths,
  });

  // Convert JSON to Membership object
  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      durationMonths: json['durationMonths'],
    );
  }

  // Convert Membership object to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'price': price,
      'durationMonths': durationMonths,
    };
  }
}
