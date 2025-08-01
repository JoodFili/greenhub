import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../utiles/constant_variable.dart' as globals;
import 'NewOrder.dart';
import 'PresentOrder.dart';
import 'Details.dart';
import 'ClientHomeScreen.dart';
import 'AccountPage.dart';
import 'FavoritesPage.dart';

class PastOrder extends StatefulWidget {
  const PastOrder({super.key});

  @override
  State<PastOrder> createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  final Color greenColor = const Color(0xFF048372);
  final Color lightGreen = const Color(0x80AECF5C);
  final Color grayColor = const Color(0xFFF6F6F6);
  int currentIndex = 2;
  List<Map<String, dynamic>> shipments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShipments(); // ✅ جلب الطلبات عند فتح الصفحة
  }

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ClientHomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const NewOrder()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const PastOrder()));
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PresentOrder()),
      );
    } else if (label == 'السابقة') {
      // الحالية
    }
  }

  void navigateToDetailsPage(Map<String, dynamic> shipment) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Details(shipment: shipment),
      ),
    );
  }

  Future<void> fetchShipments() async {
    log('🚀 Token: ${globals.authToken}');
    try {
      final response = await Dio().get(
        'http://10.0.2.2:8000/api/past-shipments',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${globals.authToken}',
            'Accept': 'application/json',
          },
        ),
      );
      setState(() {
        // 🔴 تم إزالة التصفية من جانب العميل هنا
        // لأن الخادم يقوم بالتصفية بالفعل ويرسل فقط الطلبات بحالة "تم التسليم"
        shipments = List<Map<String, dynamic>>.from(response.data);
        isLoading = false;
        log("🚚 الطلبات السابقة (من الخادم): ${shipments.toString()}");
      });
    } catch (e) {
      print("❌ Error fetching past shipments: $e");
      setState(() {
        isLoading = false;
      });
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
                    child: tabItem('الحالية', false),
                  ),
                  GestureDetector(
                    onTap: () => navigateToTab('السابقة'),
                    child: tabItem('السابقة', true, greenColor),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : shipments.isEmpty
              ? const Center(child: Text('لا توجد شحنات سابقة لهذا العميل.')) // 🔴 رسالة معدلة
              : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                ...shipments.map((shipment) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: lightGreen,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: GestureDetector(
                            onTap: () =>
                                navigateToDetailsPage(shipment),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          shipment['status'] ?? 'تم التسليم', // 🔴 قيمة افتراضية معدلة
                          style: const TextStyle(
                            fontFamily: 'Almarai',
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '#${shipment['id'] ?? ''}',
                              style: const TextStyle(
                                fontFamily: 'Almarai',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              shipment['created_at'] ??
                                  'تاريخ غير متاح',
                              style: const TextStyle(
                                fontFamily: 'Almarai',
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
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
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_2_outlined), label: 'طلباتي'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: 'المفضلة'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: 'حسابي'),
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