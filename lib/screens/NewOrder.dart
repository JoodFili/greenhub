import 'dart:developer';
import '../utiles/constant_variable.dart' as globals;
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'PresentOrder.dart';
import 'PastOrder.dart';
import 'Details.dart';
import 'ClientHomeScreen.dart';
import 'AccountPage.dart';
import 'FavoritesPage.dart';
import 'driver_confirmation.dart';

class NewOrder extends StatefulWidget {
  const NewOrder({super.key});

  @override
  State<NewOrder> createState() => _NewOrderState();
}

class _NewOrderState extends State<NewOrder> {
  final Color greenColor = const Color(0xFF048372);
  final Color grayColor = const Color(0xFFF6F6F6);
  final Color whiteColor = Colors.white;
  final Color lightGreen = const Color(0xFFAECF5C);

  int currentIndex = 1;
  List<Map<String, dynamic>> shipments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchShipments();
  }

  Future<void> fetchShipments() async {
    log('//////////////${globals.authToken}');
    try {
      final response = await Dio().get(
        'http://10.0.2.2:8000/api/pending-shipments',
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
        log("........................${shipments.toString()}");
      });
    } catch (e) {
      print("Error fetching shipments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void navigateToTab(String label) {
    if (label == 'الحالية') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PresentOrder()));
    } else if (label == 'السابقة') {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PastOrder()));
    }
  }

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientHomePage()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountPage()));
    }
  }

  Widget driverCard(Map<String, dynamic> offer, bool selected) {
    final driver = offer['driver'];
    String price = offer['price']?.toString() ?? 'لا يوجد عرض';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? lightGreen : whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.green,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  driver != null ? driver['phone'] ?? 'سائق' : 'سائق',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Text(
                '$price ر.س',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: greenColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: greenColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverConfirmationPage(
                      driver: {
                        'id': driver['id'],
                        'phone': driver['phone'],
                        'offer_id': offer['id'], // <-- أضفت هذا السطر هنا
                      },
                      price: offer['price'].toString(),
                    ),
                  ),
                );
              },
              child: const Text(
                'اختيار السائق',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
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
                  tabItem('الجديدة', true, greenColor),
                  GestureDetector(
                    onTap: () => navigateToTab('الحالية'),
                    child: tabItem('الحالية', false),
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
            : SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: shipments.length,
            itemBuilder: (context, index) {
              final shipment = shipments[index];
              final offers = shipment['offers'] as List<dynamic>;
              bool hasOffers = offers.isNotEmpty;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: greenColor, width: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'رقم الشحنة: #${shipment['id']}',
                      style: TextStyle(
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'الحالة: ${shipment['details']['status']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (hasOffers)
                      ...offers.map((offer) => driverCard(offer, false)).toList()
                    else
                      const Text(
                        'لا يوجد عروض بعد',
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                  ],
                ),
              );
            },
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
