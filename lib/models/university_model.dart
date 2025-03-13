class University {
  String id;
  String name;
  String country;
  int worldRank;

  University({
    this.id = '',
    required this.name,
    required this.country,
    required this.worldRank,
  });

  factory University.fromMap(String id, Map<String, dynamic> map) {
    return University(
      id: id,
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      worldRank: map['worldRank'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'worldRank': worldRank,
    };
  }
}