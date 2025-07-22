import 'package:flutter/material.dart';
import 'driver_home_screen.dart';


class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        leading: const BackButton(color: Colors.black),
        title: const Text(
          'الإشعارات',
          style: TextStyle(
            color: DriverHomeScreen.kPrimaryGreen,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            // قائمة الإشعارات
            Expanded(
              child: ListView(
                children: const [
                  _NotificationCard(time: 'قبل دقيقة', number: '#8977', title: 'تم قبول العرض'),
                  _NotificationCard(time: 'قبل دقيقتين', number: '#88320', title: 'طلب جديد'),
                  _NotificationCard(time: 'قبل ساعة', number: '#88320', title: 'طلب جديد'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// كارت إشعار واحد
class _NotificationCard extends StatelessWidget {
  final String time;
  final String number;
  final String title;
  const _NotificationCard({required this.time, required this.number, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: DriverHomeScreen.kPrimaryGreen, width: 1.3),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.notifications, color: DriverHomeScreen.kPrimaryGreen),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(number,
                    style: const TextStyle(
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.bold,
                        color: DriverHomeScreen.kPrimaryGreen)),
                Text(title, style: const TextStyle(fontFamily: 'Almarai')),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontFamily: 'Almarai', fontSize: 12)),
        ],
      ),
    );
  }
}