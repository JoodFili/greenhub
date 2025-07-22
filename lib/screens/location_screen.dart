import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'vehicle_screen.dart';
import 'shipment_screen.dart';
import 'NewOrder.dart';
import 'FavoritesPage.dart';
import 'AccountPage.dart';


class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final Color customGreen = const Color(0xFF048372);
  final Color backgroundGray = const Color(0xFFF2F2F2);
  late GoogleMapController _mapController;
  bool addToFavorites = false;
  static const LatLng _initialPosition = LatLng(21.4858, 39.1925);
  int _selectedIndex = 0; // Added to manage the selected tab in BottomNavigationBar

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigate based on the tapped index
    switch (index) {
      case 0:
      // 'الرئيسية' (Home) - If you removed ClientHomeScreen, this case will do nothing
      // or you can navigate to a new default home screen if you create one.
      // Example: Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewHomeScreen()));
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundGray,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex, // Use the state variable
          selectedItemColor: customGreen,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped, // Add the onTap callback
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
              // نقطة الانطلاق - نفس تصميم الشحنة
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildLabeledTextField("نقطة الانطلاق", "مكة"),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // الوجهة - نفس تصميم الشحنة
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildLabeledTextField("الوجهة", "جدة"),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // إضافة إلى المفضلة - محاذاة لليمين
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    textDirection: TextDirection.rtl,
                    children: [
                      Radio(
                        value: true,
                        groupValue: addToFavorites,
                        onChanged: (val) {
                          setState(() {
                            addToFavorites = val ?? false;
                          });
                        },
                        activeColor: customGreen,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'إضافة الموقع إلى الجهات المفضلة',
                        style: TextStyle(fontSize: 16, fontFamily: 'Almarai'),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              // الخريطة
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: customGreen),
                    borderRadius: BorderRadius.circular(12), // نفس الشكل المدور
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
              // عنوان الموقع
              Container(
                width: double.infinity,
                child: Text(
                  'السعودية، جدة، حي الفيصلية',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontFamily: 'Almarai', color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),
              // زر التالي - نفس التصميم من الشحنة
              Container(
                width: double.infinity,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => VehicleSelectionScreen()),
                      );
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  // نفس دالة buildLabeledTextField من شاشة الشحنة
  Widget buildLabeledTextField(String label, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          child: Align(
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
        ),
        SizedBox(height: 8),
        TextField(
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
            filled: true, // تمكين تعبئة الخلفية
            fillColor: Colors.white, // تعيين لون الخلفية إلى الأبيض
          ),
        ),
      ],
    );
  }
}




