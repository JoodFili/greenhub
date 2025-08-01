import 'package:flutter/material.dart';

class DriverConfirmationPage extends StatelessWidget {
  final Map<String, dynamic> driver;
  final String price;

  const DriverConfirmationPage({
    Key? key,
    required this.driver,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color greenColor = const Color(0xFF048372);
    final Color redColor = Colors.red;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6), // ← هنا تتحكم باللون
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'تفاصيل السائق',
          style: TextStyle(color: greenColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: greenColor),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: greenColor, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'رقم السائق: ${driver['id'] ?? 'غير متوفر'}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                'رقم الجوال: ${driver['phone'] ?? 'غير متوفر'}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(
                'السعر المقدم: $price ر.س',
                style: TextStyle(fontSize: 16, color: greenColor),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // نفذ عملية القبول هنا
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: greenColor,
                    ),
                    child: const Text('قبول', style: TextStyle(color: Colors.white)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // نفذ عملية الرفض هنا
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: redColor,
                    ),
                    child: const Text('رفض', style: TextStyle(color: Colors.white)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
