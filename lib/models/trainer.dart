class Trainer {
  final String id;
  final String name;
  final String email;
  final String phone;

  Trainer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory Trainer.fromJson(Map<String, dynamic> json) {
    return Trainer(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
    );
  }
}
