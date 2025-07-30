import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'NewOrder.dart';
import 'FavoritesPage.dart';
import 'AccountPage.dart';
import 'shipment_screen.dart';
import 'request_submitted_screen.dart';


class LocationScreen extends StatefulWidget {
  final String weight;
  final String type;
  final String size;
  final bool isImmediate;

  const LocationScreen({
    super.key,
    required this.size,
    required this.type,
    required this.weight,
    required this.isImmediate,
  });

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final Color customGreen = const Color(0xFF048372);
  final Color backgroundGray = const Color(0xFFF2F2F2);
  late GoogleMapController _mapController;
  static const LatLng _initialPosition = LatLng(21.4858, 39.1925);
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => NewOrder()),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => FavoritesPage()),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AccountPage()),
        );
        break;
    }
  }

  Future<void> sendShipmentData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final clientId = prefs.getInt('client_id');

    print("🚨 Token from prefs: $token");
    print("🚨 Client ID from prefs: $clientId");

    if (token == null || clientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى تسجيل الدخول مرة أخرى')),
      );
      return;
    }

    final formData = FormData.fromMap({
      'Client_id': clientId,
      'type': widget.type,
      'weight': widget.weight,
      'size': widget.size,
      'destination': destinationController.text,
      'address': addressController.text,
      'is_immediate': widget.isImmediate ? 1 : 0,
      'status': 'pending',
      'payment_method': 'unknown',
    });

    try {
      final response = await Dio().post(
        'http://192.168.0.128:8000/api/shipments',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('✅ تم إرسال الشحنة بنجاح!')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => RequestSubmittedScreen()),
        );
      } else {
        print('❌ Error Response: ${response.data}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ فشل في الإرسال، حاول مرة أخرى')),
        );
      }
    } catch (e) {
      if (e is DioException && e.response != null) {
        print('❌ DioException: ${e.response?.data}');
      } else {
        print('❌ Unknown Error: $e');
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠️ حدث خطأ أثناء الإرسال')),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundGray,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: customGreen,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
            BottomNavigationBarItem(icon: Icon(Icons.inventory_2_outlined), label: 'طلباتي'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'المفضلة'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'حسابي'),
          ],
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'تحديد الموقع',
            style: TextStyle(color: customGreen, fontFamily: 'Almarai', fontSize: 22),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: customGreen),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => shipment_screen()),
              );
            },
          ),
          iconTheme: IconThemeData(color: customGreen),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              buildLabeledTextField("نقطة الانطلاق", "مكة", addressController),
              SizedBox(height: 16),
              buildLabeledTextField("الوجهة", "جدة", destinationController),
              SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: customGreen),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: GoogleMap(
                      onMapCreated: (controller) {
                        _mapController = controller;
                      },
                      initialCameraPosition: CameraPosition(
                        target: _initialPosition,
                        zoom: 14,
                      ),
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      zoomControlsEnabled: false,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'السعودية، جدة، حي الفيصلية',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontFamily: 'Almarai', color: Colors.grey),
              ),
              SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () async {
                    await sendShipmentData();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: customGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.ltr,
                    children: const [
                      Icon(Icons.arrow_forward, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        'التالي',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Almarai',
                          fontSize: 16,
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

  Widget buildLabeledTextField(String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Almarai',
            ),
            textAlign: TextAlign.right,
          ),
        ),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey, fontFamily: 'Almarai'),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: customGreen),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: customGreen, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
