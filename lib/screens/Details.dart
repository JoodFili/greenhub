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

  @override
  void initState() {
    super.initState();
    shipment = widget.shipment;
  }

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ClientHomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PresentOrder()));
    } else if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FavoritesPage()));
    } else if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountPage()));
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
          child: Column(
            children: [
              const SizedBox(height: 25),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTextField(
                        label: 'عنوان الاستلام',
                        value: shipment['pickup_address'] ?? '',
                      ),
                      _buildTextField(
                        label: 'عنوان التوصيل',
                        value: shipment['delivery_address'] ?? '',
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              label: 'التوقيت',
                              value: shipment['time'] ?? '',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              label: 'التاريخ',
                              value: shipment['date'] ?? '',
                            ),
                          ),
                        ],
                      ),
                      _buildTextField(
                        label: 'نوع الطلب',
                        value: shipment['type'] ?? '',
                      ),
                      _buildTextField(
                        label: 'طريقة الدفع',
                        valueWidget: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(Icons.apple, color: greenColor),
                            const SizedBox(width: 8),
                            Text(shipment['payment_method'] ?? 'Apple Pay',
                                style: TextStyle(fontFamily: 'Almarai')),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildTextField(
                        label: 'ملخص الطلب',
                        valueWidget: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('اسم المنتج: ${shipment['product_name'] ?? 'طاولة طعام'}',
                                style: const TextStyle(fontFamily: 'Almarai')),
                            const SizedBox(height: 8),
                            Text('الكمية: ${shipment['quantity'] ?? '1'}',
                                style: const TextStyle(fontFamily: 'Almarai')),
                            const SizedBox(height: 8),
                            Text('سعر الوحدة: ${shipment['unit_price'] ?? '500'} ر.س',
                                style: const TextStyle(fontFamily: 'Almarai')),
                            const SizedBox(height: 8),
                            Text('الإجمالي: ${shipment['total'] ?? '500'} ر.س',
                                style: const TextStyle(fontFamily: 'Almarai')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
