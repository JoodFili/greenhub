import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ClientHomeScreen.dart';
import 'PresentOrder.dart';
import 'FavoritesPage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final Color greenColor = const Color(0xFF048372);
  final Color grayColor = const Color(0xFFF6F6F6);

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedCity;
  String? _token;

  final List<String> _cities = ['جدة', 'الرياض', 'مكة'];

  int currentIndex = 3; // لأن حسابي هو التاب رقم 3 في الناف بار

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');

    _usernameController.text = prefs.getString('name') ?? '';
    _phoneController.text = prefs.getString('phone') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _selectedCity = prefs.getString('city');
    setState(() {});
  }

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ClientHomePage(),
          ));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const PresentOrder(),
          ));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const FavoritesPage(),
          ));
    } else if (index == 3) {
      // انت حالياً في صفحة حسابي، فلا حاجة للتنقل
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('يرجى تعبئة جميع الحقول'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    if (_token == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('المستخدم غير مسجل الدخول'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final formData = FormData.fromMap({
      "name": _usernameController.text.trim(),
      "email": _emailController.text.trim(),
      "phone": _phoneController.text.trim(),
      "city": _selectedCity,
    });

    try {
      final response = await Dio().post(
        "http://192.168.0.128:8000/api/profile",
        data: formData,
        options: Options(
          headers: {
            "Authorization": "Bearer $_token",
            "Accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200 && response.data['status'] == true) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', _usernameController.text.trim());
        await prefs.setString('email', _emailController.text.trim());
        await prefs.setString('phone', _phoneController.text.trim());
        await prefs.setString('city', _selectedCity!);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('تم حفظ التعديلات بنجاح'),
          backgroundColor: greenColor,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.data['message'] ?? 'فشل في تحديث البيانات'),
          backgroundColor: Colors.red,
        ));
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.response?.data['message'] ?? 'حدث خطأ غير متوقع'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: grayColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'حسابي',
            style: TextStyle(
              color: greenColor,
              fontFamily: 'Almarai',
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios, color: greenColor),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onBottomNavItemTapped,
          selectedItemColor: greenColor,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'طلباتي'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'المفضلة'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTextField(
                    label: 'اسم المستخدم',
                    controller: _usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال اسم المستخدم';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[\u0600-\u06FFa-zA-Z0-9\s]'),
                      ),
                    ],
                  ),
                  _buildTextField(
                    label: 'رقم الجوال',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رقم الجوال';
                      }
                      if (!value.startsWith('05') ||
                          value.length != 10 ||
                          !RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'رقم الجوال يجب أن يبدأ بـ 05 ويتكون من 10 أرقام';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    label: 'البريد الإلكتروني',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال البريد الإلكتروني';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'البريد الإلكتروني غير صالح';
                      }
                      return null;
                    },
                  ),
                  _buildDropdownField(),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'حفظ التعديلات',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Almarai',
                fontSize: 16)),
        const SizedBox(height: 6),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: greenColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              inputFormatters: inputFormatters,
              style: const TextStyle(fontFamily: 'Almarai'),
              decoration: InputDecoration(
                hintStyle:
                TextStyle(color: Colors.grey[400], fontFamily: 'Almarai'),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المدينة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: greenColor),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: _selectedCity,
              hint: Text('اختر المدينة',
                  style: TextStyle(
                      color: Colors.grey[400], fontFamily: 'Almarai')),
              items: _cities
                  .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item,
                      style: const TextStyle(fontFamily: 'Almarai'))))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCity = value),
              validator: (value) =>
              value == null ? 'الرجاء اختيار المدينة' : null,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}



