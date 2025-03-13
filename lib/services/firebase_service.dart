import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/university_model.dart';

class FirebaseService {
  final CollectionReference _universitiesCollection = 
      FirebaseFirestore.instance.collection('University');

  // เพิ่มข้อมูลมหาวิทยาลัย
  Future<void> addUniversity(University university) async {
    await _universitiesCollection.add(university.toMap());
  }

  // ดึงข้อมูลมหาวิทยาลัยทั้งหมด
  Stream<List<University>> getUniversities() {
    return _universitiesCollection
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => University.fromMap(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // ดึงข้อมูลมหาวิทยาลัยตาม ID
  Future<University> getUniversity(String id) async {
    final doc = await _universitiesCollection.doc(id).get();
    return University.fromMap(doc.id, doc.data() as Map<String, dynamic>);
  }

  // อัพเดทข้อมูลมหาวิทยาลัย (เฉพาะชื่อและอันดับโลก)
  Future<void> updateUniversity(String id, String name, int worldRank) async {
    await _universitiesCollection.doc(id).update({
      'name': name,
      'worldRank': worldRank,
    });
  }

  // ลบข้อมูลมหาวิทยาลัย
  Future<void> deleteUniversity(String id) async {
    await _universitiesCollection.doc(id).delete();
  }
}