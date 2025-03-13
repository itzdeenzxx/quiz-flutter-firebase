import 'package:flutter/material.dart';
import '../models/university_model.dart';
import '../services/firebase_service.dart';
import '../widgets/university_card.dart';
import '../theme/app_theme.dart';
import 'add_university_screen.dart';
import 'edit_university_screen.dart';
import 'university_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายชื่อมหาวิทยาลัย'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showInfoDialog(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<University>>(
        stream: _firebaseService.getUniversities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppTheme.errorColor,
                    size: 60,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'เกิดข้อผิดพลาด: ${snapshot.error}',
                    style: const TextStyle(color: AppTheme.errorColor),
                  ),
                ],
              ),
            );
          }

          final universities = snapshot.data ?? [];

          if (universities.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/empty.jpg', width: 120, height: 120),
                  const SizedBox(height: 16),
                  const Text(
                    'ยังไม่มีข้อมูลมหาวิทยาลัย',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.lightTextColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'กดปุ่ม + เพื่อเพิ่มมหาวิทยาลัยใหม่',
                    style: TextStyle(color: AppTheme.lightTextColor),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 16),
            itemCount: universities.length,
            itemBuilder: (context, index) {
              final university = universities[index];
              return UniversityCard(
                university: university,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              UniversityDetailScreen(university: university),
                    ),
                  );
                },
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              EditUniversityScreen(university: university),
                    ),
                  );
                },
                onDelete: () {
                  _showDeleteConfirmationDialog(context, university);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddUniversityScreen(),
            ),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    University university,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยืนยันการลบ'),
          content: Text('คุณต้องการลบ ${university.name} ใช่หรือไม่?'),
          actions: [
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'ลบ',
                style: TextStyle(color: AppTheme.errorColor),
              ),
              onPressed: () async {
                Navigator.of(context).pop();
                await _firebaseService.deleteUniversity(university.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('ลบข้อมูลมหาวิทยาลัยเรียบร้อย'),
                      backgroundColor: AppTheme.successColor,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('เกี่ยวกับแอปพลิเคชัน'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'แอปพลิเคชันจัดการข้อมูลมหาวิทยาลัย',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('• เพิ่มข้อมูลมหาวิทยาลัย'),
              Text('• แก้ไขชื่อและอันดับโลก'),
              Text('• ดูรายละเอียดมหาวิทยาลัย'),
              Text('• ลบข้อมูลมหาวิทยาลัย'),
              SizedBox(height: 8),
              Text(
                'พัฒนาด้วย Flutter และ Firebase',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('ปิด'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
