import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import 'driver_home_screen.dart';

class DriverProfileScreen extends StatefulWidget {
  const DriverProfileScreen({super.key});

  static const Color kPrimaryGreen = Color(0xFF048372);

  @override
  _DriverProfileScreenState createState() => _DriverProfileScreenState();
}

class _DriverProfileScreenState extends State<DriverProfileScreen> {
  File? _imageFile;
  final picker = ImagePicker();
  DateTime? _selectedDate;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _docsController = TextEditingController();
  String? _selectedCity;
  String? _errorText = '';

  final List<String> _cities = ['الرياض', 'جدة', 'الدمام', 'مكة', 'المدينة'];
  String? _token;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    _nameController.text = prefs.getString('name') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _idController.text = prefs.getString('national_ID') ?? '';
    _phoneController.text = prefs.getString('phone') ?? '';
    _docsController.text = prefs.getString('documents') ?? '';
    _selectedCity = prefs.getString('city');
    final dateString = prefs.getString('birth_date');
    if (dateString != null) {
      _selectedDate = DateTime.tryParse(dateString);
    }

    final imagePath = prefs.getString('profile_image_path');
    if (imagePath != null && File(imagePath).existsSync()) {
      _imageFile = File(imagePath);
    }
    setState(() {});
  }

  Future<void> _pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      helpText: 'اختر تاريخ الميلاد',
      builder: (c, child) => Theme(
        data: Theme.of(c).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFAECF5C)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  OutlineInputBorder _greenBorder() => const OutlineInputBorder(
      borderSide: BorderSide(color: DriverProfileScreen.kPrimaryGreen));

  String? _validateNotEmpty(String? v) =>
      (v == null || v.trim().isEmpty) ? 'هذا الحقل مطلوب' : null;
  String? _validatePhone(String? v) {
    if (v == null || v.trim().isEmpty) return 'رقم الجوال مطلوب';
    if (!RegExp(r'^\d{9}$').hasMatch(v)) return 'رقم الجوال يجب 9 أرقام';
    return null;
  }

  String? _validateEmail(String? v) =>
      (v == null || !v.contains('@')) ? 'الإيميل غير صالح' : null;

  Future<void> _submitProfile() async {
    if (!_formKey.currentState!.validate() ||
        _selectedCity == null ||
        _selectedDate == null) {
      setState(() => _errorText = 'يرجى تعبئة جميع الحقول المطلوبة');
      return;
    }
    setState(() => _errorText = '');
    if (_token == null) {
      setState(() => _errorText = 'المستخدم غير مسجل الدخول');
      return;
    }
    print('TOKEN = $_token');

    final formData = FormData.fromMap({
      "name": _nameController.text.trim(),
      "email": _emailController.text.trim(),
      "national_ID": _idController.text.trim(),
      "birth_date": _selectedDate!.toIso8601String(),
      "city": _selectedCity,
      "phone": _phoneController.text.trim(),
      "documents": _docsController.text.trim(),
    });

    try {
      final response = await Dio().post(
        "http://192.168.1.85:8000/api/profile",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'name', formData.fields.firstWhere((f) => f.key == 'name').value);
        await prefs.setString(
            'email', formData.fields.firstWhere((f) => f.key == 'email').value);
        await prefs.setString('national_ID',
            formData.fields.firstWhere((f) => f.key == 'national_ID').value);
        await prefs.setString(
            'phone', formData.fields.firstWhere((f) => f.key == 'phone').value);
        await prefs.setString('documents',
            formData.fields.firstWhere((f) => f.key == 'documents').value);
        await prefs.setString(
            'city', formData.fields.firstWhere((f) => f.key == 'city').value);
        await prefs.setString('birth_date',
            formData.fields.firstWhere((f) => f.key == 'birth_date').value);
        if (_imageFile != null) {
          await prefs.setString('profile_image_path', _imageFile!.path);
        }

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
            (r) => false);
      } else {
        setState(() {
          _errorText = response.data['message'] ?? 'فشل في تحديث البيانات';
        });
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 422) {
        print('Validation error: ${e.response?.data}');
        setState(() {
          _errorText = e.response?.data['message'] ?? 'خطأ في البيانات المرسلة';
        });
      } else {
        print('Unexpected error: ${e.message}');
        setState(() => _errorText = 'حدث خطأ غير متوقع');
      }
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text('حسابي',
            style: TextStyle(
                color: DriverProfileScreen.kPrimaryGreen,
                fontSize: 25,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DefaultTextStyle.merge(
          style: const TextStyle(fontFamily: 'Almarai', fontSize: 20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _imageFile != null
                                ? FileImage(_imageFile!)
                                : null,
                            child: _imageFile == null
                                ? const Icon(Icons.camera_alt,
                                    size: 40, color: Colors.grey)
                                : null,
                            backgroundColor: Colors.grey[200])),
                    const SizedBox(height: 20),
                    _buildTextField('الاسم:', _nameController,
                        validator: _validateNotEmpty),
                    _buildTextField('رقم الهوية:', _idController,
                        validator: _validateNotEmpty),
                    _buildDateField(),
                    _buildTextField('رقم الجوال:', _phoneController,
                        keyboard: TextInputType.phone,
                        validator: _validatePhone),
                    _buildTextField('الإيميل:', _emailController,
                        keyboard: TextInputType.emailAddress,
                        validator: _validateEmail),
                    _buildTextField('المستندات:', _docsController,
                        validator: _validateNotEmpty),
                    _buildCityDropdown(),
                    const SizedBox(height: 10),
                    if (_errorText != null && _errorText!.isNotEmpty)
                      Text(_errorText!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    Align(
                        child: SizedBox(
                            width: 110,
                            height: 44,
                            child: ElevatedButton(
                                onPressed: _submitProfile,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        DriverProfileScreen.kPrimaryGreen,
                                    elevation: 0),
                                child: const Text('الحفظ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Almarai',
                                        color: Colors.white))))),
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
          {TextInputType keyboard = TextInputType.text,
          String? Function(String?)? validator}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label),
        const SizedBox(height: 6),
        TextFormField(
            controller: controller,
            keyboardType: keyboard,
            textAlign: TextAlign.right,
            validator: validator,
            decoration: InputDecoration(
                enabledBorder: _greenBorder(),
                focusedBorder: _greenBorder(),
                border: _greenBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14))),
        const SizedBox(height: 16)
      ]);

  Widget _buildDateField() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('تاريخ الميلاد:'),
        const SizedBox(height: 6),
        GestureDetector(
            onTap: _pickDate,
            child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: DriverProfileScreen.kPrimaryGreen),
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                    _selectedDate == null
                        ? 'اختر تاريخ الميلاد'
                        : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                        color: _selectedDate == null
                            ? Colors.grey
                            : Colors.black)))),
        const SizedBox(height: 16)
      ]);

  Widget _buildCityDropdown() =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('المدينة:'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
            decoration: InputDecoration(
                border: _greenBorder(),
                enabledBorder: _greenBorder(),
                focusedBorder: _greenBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 14)),
            iconEnabledColor: DriverProfileScreen.kPrimaryGreen,
            value: _selectedCity,
            validator: (v) => v == null ? 'اختر مدينة' : null,
            items: _cities
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) => setState(() => _selectedCity = v)),
        const SizedBox(height: 16)
      ]);
}
