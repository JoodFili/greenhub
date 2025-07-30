import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddFavorite extends StatefulWidget {
  const AddFavorite({super.key});

  @override
  State<AddFavorite> createState() => _AddFavoriteState();
}

class _AddFavoriteState extends State<AddFavorite> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  bool _isLoading = false;

  Future<void> _addFavorite() async {
    setState(() {
      _isLoading = true;
    });
    final dio = Dio();
    const String apiUrl = 'http://192.168.0.128:8000/api/favorite-destinations';
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token'); // ✅ هذا هو الاسم الصحيح اللي خزّنتيه من صفحة التحقق
      if (token == null || token.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
          );
        }
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final response = await dio.post(
        apiUrl,
        data: {
          'destination': destinationController.text,
          'address': addressController.text,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      if (mounted) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تمت إضافة الوجهة المفضلة بنجاح!')),
          );
          // 💡 هذا السطر هو اللي يرجع البيانات المضافة للصفحة السابقة
          Navigator.pop(context, {
            'destination': destinationController.text,
            'address': addressController.text,
            // يمكنك إضافة أي حقول أخرى يرجعها الخادم هنا
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('فشل في الإضافة: ${response.statusCode}')),
          );
        }
      }
    } on DioException catch (e) {
      if (mounted) {
        String errorMessage = 'خطأ أثناء الإضافة: ';
        if (e.response != null) {
          errorMessage += 'الخادم استجاب بحالة ${e.response?.statusCode}. البيانات: ${e.response?.data}';
        } else {
          errorMessage += e.message ?? 'خطأ غير معروف';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ غير متوقع: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  @override
  void dispose() {
    destinationController.dispose();
    addressController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Color greenColor = const Color(0xFF048372);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "إضافة وجهة مفضلة",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: greenColor),
            onPressed: () {
              Navigator.pop(context,true);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: 'الوجهة',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: greenColor, width: 2),
                  ),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'العنوان',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: greenColor, width: 2),
                  ),
                ),
                textAlign: TextAlign.right,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _addFavorite,
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'إضافة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
