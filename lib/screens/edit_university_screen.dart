import 'package:flutter/material.dart';
import '../models/university_model.dart';
import '../services/firebase_service.dart';
import '../widgets/custom_text_field.dart';
import '../theme/app_theme.dart';

class EditUniversityScreen extends StatefulWidget {
  final University university;

  const EditUniversityScreen({Key? key, required this.university}) : super(key: key);

  @override
  State<EditUniversityScreen> createState() => _EditUniversityScreenState();
}

class _EditUniversityScreenState extends State<EditUniversityScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _worldRankController;
  final _firebaseService = FirebaseService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.university.name);
    _worldRankController = TextEditingController(text: widget.university.worldRank.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _worldRankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('แก้ไขข้อมูลมหาวิทยาลัย'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'ชื่อมหาวิทยาลัย',
                hint: 'กรอกชื่อมหาวิทยาลัย',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อมหาวิทยาลัย';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ข้อมูลที่ไม่สามารถแก้ไขได้',
                      style: TextStyle(
                        color: AppTheme.lightTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ประเทศ: ${widget.university.country}',
                      style: const TextStyle(color: AppTheme.lightTextColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                label: 'อันดับโลก',
                hint: 'กรอกอันดับโลก',
                controller: _worldRankController,
                isNumber: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกอันดับโลก';
                  }
                  try {
                    int rank = int.parse(value);
                    if (rank <= 0) {
                      return 'อันดับโลกต้องมากกว่า 0';
                    }
                  } catch (e) {
                    return 'กรุณากรอกเป็นตัวเลขเท่านั้น';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: const Text('บันทึกการแก้ไข'),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.edit_document,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'แก้ไข ${widget.university.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                const Text(
                  'คุณสามารถแก้ไขเฉพาะชื่อและอันดับโลกเท่านั้น',
                  style: TextStyle(
                    color: AppTheme.lightTextColor,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _firebaseService.updateUniversity(
          widget.university.id,
          _nameController.text.trim(),
          int.parse(_worldRankController.text.trim()),
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('อัพเดทข้อมูลมหาวิทยาลัยสำเร็จ'),
              backgroundColor: AppTheme.successColor,
            ),
          );

          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('เกิดข้อผิดพลาด: $e'),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      }
    }
  }
}