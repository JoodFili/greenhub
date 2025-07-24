import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'driver_profile_screen.dart';
import 'driver_home_screen.dart';

class CarDetailsScreen extends StatefulWidget {
  const CarDetailsScreen({super.key});
  @override
  State<CarDetailsScreen> createState() => _CarDetailsScreenState();
}

class _CarDetailsScreenState extends State<CarDetailsScreen> {
  final _typeCtrl = TextEditingController();
  final _modelCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();

  File? _licenseImage;
  File? _carImage;
  final _picker = ImagePicker();

  Future<void> _pickFile(bool isLicense) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isLicense) {
          _licenseImage = File(picked.path);
        } else {
          _carImage = File(picked.path);
        }
      });
    }
  }

  OutlineInputBorder _greenBorder() => const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF048372)),
      );

  void _handleSave() {
    final type = _typeCtrl.text.trim();
    final model = _modelCtrl.text.trim();
    final plate = _plateCtrl.text.trim();

    if (type.isEmpty || model.isEmpty || plate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى تعبئة جميع الحقول')),
      );
      return;
    }

    if (_licenseImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إرفاق صورة رخصة القيادة')),
      );
      return;
    }

    if (_carImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إرفاق صورة المركبة')),
      );
      return;
    }

    // كل شيء تمام → انتقل للصفحة التالية
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        leading: const BackButton(color: Color(0xFF048372)),
        title: const Text('تفاصيل المركبة',
            style: TextStyle(
                color: Color(0xFF048372),
                fontSize: 25,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DefaultTextStyle.merge(
          style: const TextStyle(fontFamily: 'Almarai', fontSize: 18),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _uploadRow(label: 'رخصة القيادة:', isLicense: true),
                _textField('نوع المركبة:', _typeCtrl),
                _textField('موديل المركبة:', _modelCtrl),
                _textField('لوحة المركبة:', _plateCtrl),
                _uploadRow(label: 'صورة المركبة:', isLicense: false),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: 110,
                    height: 44,
                    child: ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF048372),
                        elevation: 0,
                      ),
                      child: const Text('الحفظ',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _textField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            enabledBorder: _greenBorder(),
            focusedBorder: _greenBorder(),
            border: _greenBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _uploadRow({required String label, required bool isLicense}) {
    final File? file = isLicense ? _licenseImage : _carImage;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _pickFile(isLicense),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[400],
                elevation: 0,
                minimumSize: const Size(80, 36),
              ),
              child: const Text('إرفاق', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            if (file != null)
              Expanded(
                child: Text(file.path.split('/').last,
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14)),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
