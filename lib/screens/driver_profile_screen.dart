import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'car_details_screen.dart';
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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _docsController = TextEditingController();
  String? _selectedCity;

  final List<String> _cities = ['الرياض', 'جدة', 'الدمام', 'مكة', 'المدينة'];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) setState(() => _imageFile = File(pickedFile.path));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
      helpText: 'اختر تاريخ الميلاد',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFAECF5C),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  OutlineInputBorder _greenBorder() => const OutlineInputBorder(
        borderSide: BorderSide(color: DriverProfileScreen.kPrimaryGreen),
      );

  String? _validateNotEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return 'رقم الجوال مطلوب';
    if (!RegExp(r'^\d{9}$').hasMatch(value))
      return 'رقم الجوال يجب أن يكون 9 أرقام';
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return 'الإيميل مطلوب';
    if (!value.contains('@')) return 'الإيميل غير صالح';
    return null;
  }

  String? _errorText = '';

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16.0),
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
                      backgroundImage:
                          _imageFile != null ? FileImage(_imageFile!) : null,
                      child: _imageFile == null
                          ? const Icon(Icons.camera_alt,
                              size: 40, color: Colors.grey)
                          : null,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('الاسم:', _nameController,
                      validator: _validateNotEmpty),
                  _buildTextField('رقم الهوية:', _idController,
                      validator: _validateNotEmpty),
                  _buildDateField(),
                  _buildTextField('رقم الجوال:', _phoneController,
                      keyboard: TextInputType.phone, validator: _validatePhone),
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
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (_selectedDate == null) {
                              setState(() =>
                                  _errorText = 'يرجى اختيار تاريخ الميلاد');
                              return;
                            }
                            if (_selectedCity == null) {
                              setState(
                                  () => _errorText = 'يرجى اختيار المدينة');
                              return;
                            }
                            setState(() => _errorText = '');
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const DriverHomeScreen()),
                              (route) => false,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: DriverProfileScreen.kPrimaryGreen,
                          elevation: 0,
                        ),
                        child: const Text('الحفظ',
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Almarai',
                                color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboard = TextInputType.text,
      String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('تاريخ الميلاد:'),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: DriverProfileScreen.kPrimaryGreen),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              _selectedDate == null
                  ? 'اختر تاريخ الميلاد'
                  : '${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}',
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: _selectedDate == null ? Colors.grey : Colors.black),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('المدينة:'),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            border: _greenBorder(),
            enabledBorder: _greenBorder(),
            focusedBorder: _greenBorder(),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
          ),
          iconEnabledColor: DriverProfileScreen.kPrimaryGreen,
          value: _selectedCity,
          validator: (value) => value == null ? 'اختر مدينة' : null,
          items: _cities
              .map((city) => DropdownMenuItem(value: city, child: Text(city)))
              .toList(),
          onChanged: (value) => setState(() => _selectedCity = value),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
