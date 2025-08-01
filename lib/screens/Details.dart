import 'package:flutter/material.dart';
import 'ClientHomeScreen.dart';
import 'PresentOrder.dart';
import 'FavoritesPage.dart';
import 'AccountPage.dart';

class Details extends StatefulWidget {
  final Map<String, dynamic> shipment;

  const Details({super.key, required this.shipment});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  final Color greenColor = const Color(0xFF048372);
  final Color grayColor = const Color(0xFFF6F6F6);
  final Color yellowColor = const Color(0xFFFFD600);
  int currentIndex = 1;
  late Map<String, dynamic> shipment;
  late Map<String, dynamic> details;

  @override
  void initState() {
    super.initState();
    shipment = widget.shipment;
    details = shipment['details'] ?? {};
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
          context, MaterialPageRoute(builder: (context) => const PresentOrder()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AccountPage()));
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
            onPressed: () {
              Navigator.pop(context);
            },
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  label: 'عنوان الاستلام',
                  value: details['address'] ?? '',
                ),
                _buildTextField(
                  label: 'عنوان التوصيل',
                  value: details['destination'] ?? '',
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        label: 'التوقيت',
                        value: details['scheduled_time'] ?? '',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        label: 'التاريخ',
                        value: details['scheduled_date'] ?? '',
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  label: 'نوع الطلب',
                  value: details['type'] ?? '',
                ),
                _buildTextField(
                  label: 'طريقة الدفع',
                  valueWidget: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.payment, color: greenColor),
                      const SizedBox(width: 8),
                      Text(
                        details['payment_method'] ?? 'غير محدد',
                        style: TextStyle(fontFamily: 'Almarai'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'ملخص الطلب',
                  value: details['summary'] ?? '',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    String? value,
    Widget? valueWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Almarai',
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: greenColor, width: 1.5),
          ),
          child: valueWidget ??
              Text(
                value ?? '',
                style: const TextStyle(fontFamily: 'Almarai'),
                textAlign: TextAlign.right,
              ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
