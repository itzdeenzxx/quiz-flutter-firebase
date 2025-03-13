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

  // แปลงข้อมูลจาก Map (Firebase) เป็น University object
  factory University.fromMap(String id, Map<String, dynamic> map) {
    return University(
      id: id,
      name: map['name'] ?? '',
      country: map['country'] ?? '',
      worldRank: map['worldRank'] ?? 0,
    );
  }

  // แปลงข้อมูลจาก University object เป็น Map สำหรับเก็บใน Firebase
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'country': country,
      'worldRank': worldRank,
    };
  }
}