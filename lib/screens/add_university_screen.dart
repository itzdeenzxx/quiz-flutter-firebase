import 'package:flutter/material.dart';
import '../models/university_model.dart';
import '../services/firebase_service.dart';
import '../widgets/custom_text_field.dart';
import '../theme/app_theme.dart';

class AddUniversityScreen extends StatefulWidget {
  const AddUniversityScreen({Key? key}) : super(key: key);

  @override
  State<AddUniversityScreen> createState() => _AddUniversityScreenState();
}

class _AddUniversityScreenState extends State<AddUniversityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _countryController = TextEditingController();
  final _worldRankController = TextEditingController();
  final _firebaseService = FirebaseService();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _countryController.dispose();
    _worldRankController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มมหาวิทยาลัยใหม่'),
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
              CustomTextField(
                label: 'ประเทศ',
                hint: 'กรอกชื่อประเทศ',
                controller: _countryController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'กรุณากรอกชื่อประเทศ';
                  }
                  return null;
                },
              ),
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
              const SizedBox(height: 24),
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
                      child: const Text('บันทึกข้อมูล'),
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
              Icons.school,
              color: AppTheme.primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'เพิ่มข้อมูลมหาวิทยาลัย',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'กรอกข้อมูลให้ครบถ้วน',
                  style: TextStyle(
                    color: AppTheme.lightTextColor,
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
        final university = University(
          name: _nameController.text.trim(),
          country: _countryController.text.trim(),
          worldRank: int.parse(_worldRankController.text.trim()),
        );

        await _firebaseService.addUniversity(university);

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('เพิ่มข้อมูลมหาวิทยาลัยสำเร็จ'),
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