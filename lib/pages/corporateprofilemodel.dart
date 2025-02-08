class Corporation {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final List<String> sectors;
  final String description;
  final int csrBudget;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Location location;

  Corporation({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.sectors,
    required this.description,
    required this.csrBudget,
    required this.createdAt,
    required this.updatedAt,
    required this.location,
  });

  factory Corporation.fromJson(Map<String, dynamic> json) {
    return Corporation(
      id: json['_id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      sectors: List<String>.from(json['sectors'] as List),
      description: json['description'] as String,
      csrBudget: json['csr_budget'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'sectors': sectors,
      'description': description,
      'csr_budget': csrBudget,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'location': location.toJson(),
    };
  }
}

class Location {
  final String type;
  final List<double> coordinates;

  Location({
    required this.type,
    required this.coordinates,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      type: json['type'] as String,
      coordinates: List<double>.from(json['coordinates'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
}
