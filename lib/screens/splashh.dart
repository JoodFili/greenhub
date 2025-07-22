import 'package:flutter/material.dart';
import 'ClientVerification.dart'; // ✅ يبقى كما هو للعميل
import 'driver_profile_screen.dart'; // ✅ إضافة استيراد صفحة السائق

class SplashhPage extends StatelessWidget {
  const SplashhPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white, // ✅ خلفية بيضاء
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 60),
              const Text(
                'أهلاً بك',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF048372), // ✅ أخضر غامق
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'اختر طريقة الدخول',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600], // ✅ رمادي فاتح
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {
                    // ✅ يبقى كما هو - الانتقال كعميل إلى ClientVerificationPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ClientVerificationPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF048372), // ✅ زر أخضر
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'الدخول كعميل',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white, // ✅ نص أبيض
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  onPressed: () {

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DriverProfileScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF048372),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'الدخول كسائق',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Almarai',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}