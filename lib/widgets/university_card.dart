import 'package:flutter/material.dart';
import '../models/university_model.dart';
import '../theme/app_theme.dart';

class UniversityCard extends StatelessWidget {
  final University university;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onTap;

  const UniversityCard({
    Key? key,
    required this.university,
    required this.onEdit,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // ไอคอนและพื้นหลังวงกลม
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    university.name.isNotEmpty ? university.name[0].toUpperCase() : "U",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // ข้อมูลมหาวิทยาลัย
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      university.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Color(0xFFFFC107),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'อันดับโลก: ${university.worldRank}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.lightTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // ปุ่มแก้ไขและลบ
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppTheme.primaryColor),
                    onPressed: onEdit,
                    tooltip: 'แก้ไข',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: AppTheme.errorColor),
                    onPressed: onDelete,
                    tooltip: 'ลบ',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}