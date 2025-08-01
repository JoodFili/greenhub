import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'NewOrder.dart';
import 'PastOrder.dart';
import 'Details.dart';
import 'ClientHomeScreen.dart';
import 'AccountPage.dart';
import 'FavoritesPage.dart';
import '../utiles/constant_variable.dart' as globals;

class PresentOrder extends StatefulWidget {
  const PresentOrder({super.key});

  @override
  State<PresentOrder> createState() => _PresentOrderState();
}

class _PresentOrderState extends State<PresentOrder> {
  final Color greenColor = const Color(0xFF048372);
  final Color lightGreen = const Color(0x80AECF5C);
  final Color grayColor = const Color(0xFFF6F6F6);
  int currentIndex = 2; // تأكد من أن هذا المؤشر يتوافق مع العنصر الصحيح في BottomNavigationBar

  List<Map<String, dynamic>> shipments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShipments();
  }

  Future<void> fetchShipments() async {
    log('📦 التوكن: ${globals.authToken}');
    try {
      final response = await Dio().get(
        'http://10.0.2.2:8000/api/present-shipments',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${globals.authToken}',
            'Accept': 'application/json',
          },
        ),
      );
      setState(() {
        shipments = List<Map<String, dynamic>>.from(response.data);
        isLoading = false;
      });
      log("✅ البيانات: ${shipments.toString()}");
    } catch (e) {
      print("❌ فشل في جلب الشحنات: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const ClientHomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NewOrder()));
    } else if (index == 2) {
      // هذا هو العنصر الحالي، لا تفعل شيئًا أو أعد تحميل الصفحة إذا لزم الأمر
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PresentOrder()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AccountPage()));
    }
  }

  void navigateToTab(String label) {
    if (label == 'الجديدة') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NewOrder()),
      );
    } else if (label == 'الحالية') {
      // الحالية (نفس الصفحة)
    } else if (label == 'السابقة') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PastOrder()),
      );
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
            'طلباتي',
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
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => navigateToTab('الجديدة'),
                    child: tabItem('الجديدة', false),
                  ),
                  GestureDetector(
                    onTap: () => navigateToTab('الحالية'),
                    child: tabItem('الحالية', true, greenColor),
                  ),
                  GestureDetector(
                    onTap: () => navigateToTab('السابقة'),
                    child: tabItem('السابقة', false),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : shipments.isEmpty
            ? const Center(child: Text('لا توجد شحنات حالياً'))
            : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ...shipments.map((shipment) {
                // التحقق من وجود 'details' و 'is_immediate'
                final bool isScheduled = shipment['details'] != null &&
                    shipment['details']['is_immediate'] == 0;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details(shipment: shipment),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: greenColor,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // إضافة مربع "مجدول" هنا
                        if (isScheduled)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.yellow, // خلفية صفراء
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'مجدول',
                              style: TextStyle(
                                color: greenColor, // نص أخضر
                                fontFamily: 'Almarai',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (isScheduled)
                          const SizedBox(height: 8), // مسافة بعد المربع إذا كان موجودًا

                        Align(
                          alignment: Alignment.topLeft,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: greenColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          shipment['status'] ?? 'قيد التنفيذ',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            color: greenColor,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '#${shipment['id'] ?? ''}',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                color: greenColor,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              shipment['created_at'] ?? 'تاريخ غير متاح',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                color: greenColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
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
      ),
    );
  }

  Widget tabItem(String label, bool selected, [Color? selectedColor]) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 16,
            color: selected ? selectedColor ?? Colors.black : Colors.black,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        if (selected)
          Container(
            margin: const EdgeInsets.only(top: 4),
            height: 2,
            width: 60,
            color: selectedColor ?? Colors.black,
          )
      ],
    );
  }
}