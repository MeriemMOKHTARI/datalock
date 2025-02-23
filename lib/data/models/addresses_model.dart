class Address {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String icon;
  final String color;
  
  Address({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.icon,
    required this.color,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'icon': icon,
      'color': color,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      id: map['id'],
      name: map['name'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      icon: map['icon'],
      color: map['color'],
    );
  }
}