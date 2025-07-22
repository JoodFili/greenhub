import 'package:flutter/material.dart';
import 'request_submitted_screen.dart';
import 'NewOrder.dart';
import 'FavoritesPage.dart';
import 'AccountPage.dart';


class VehicleSelectionScreen extends StatefulWidget {
  const VehicleSelectionScreen({super.key});

  @override
  State<VehicleSelectionScreen> createState() => _VehicleSelectionScreenState();
}

class _VehicleSelectionScreenState extends State<VehicleSelectionScreen> {
  final Color customGreen = const Color(0xFF048372);
  final Color backgroundGray = const Color(0xFFF2F2F2);
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
          centerTitle: true,
          title: Text(
            'تحديد المركبة',
            style: TextStyle(color: customGreen, fontFamily: 'Almarai', fontSize: 22),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: customGreen),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: customGreen),
        ),
        body: Container(
          color: backgroundGray,
          padding: const EdgeInsets.all(16),
          child: Theme(
            data: Theme.of(context).copyWith(
              textTheme: Theme.of(context).textTheme.apply(
                fontFamily: 'Almarai',
                bodyColor: Colors.black,
                displayColor: Colors.black,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildOption("فئة المركبة", "مفتوح / مغلق", customGreen),
                    ],
                  ),
                ),
                //
                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildOption("تحديد الوزن", "خفيف / ثقيل / ثقيل جداً", customGreen),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildDropdown(""
                          "اختر نوع المركبة", [
                        {'name': 'سيارة', 'image': 'image1.png'},
                        {'name': 'دباب', 'image': 'image2.png'},
                      ], customGreen),
                    ],
                  ),
                ),
                const Spacer(),

                Container(
                  width: double.infinity,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => RequestSubmittedScreen()),
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
      ),
    );
  }

  Widget _buildOption(String label, String hint, Color customGreen) {
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Almarai'
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const SizedBox(height: 8),

        TextFormField(
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Almarai',
              color: Colors.grey,
              fontSize: 16,
            ),
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
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildDropdown(String label, List<Map<String, String>> items, Color customGreen) {
    return StatefulBuilder(
      builder: (context, setState) {
        String? selected;
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
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Almarai'
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            const SizedBox(height: 8),

            Container(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  hintText: "",
                  hintStyle: TextStyle(
                    fontFamily: 'Almarai',
                    color: Colors.grey,
                    fontSize: 16,
                  ),
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
                value: selected,
                isExpanded: true,

                style: TextStyle(
                  fontFamily: 'Almarai',
                  color: Colors.black,
                  fontSize: 16,
                ),

                selectedItemBuilder: (BuildContext context) {
                  return items.map<Widget>((Map<String, String> item) {
                    return Container(
                      width: double.infinity,
                      alignment: Alignment.centerRight,
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [

                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Image.asset(
                                'assets/images/${item['image']}',
                                width: 24,
                                height: 24,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    item['name'] == 'سيارة' ? Icons.directions_car : Icons.motorcycle,
                                    size: 24,
                                    color: customGreen,
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 8),

                            Expanded(
                              child: Text(
                                item['name']!,
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList();
                },
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item['name'],
                    alignment: AlignmentDirectional.centerEnd,
                    child: Container(
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        textDirection: TextDirection.rtl,
                        children: [

                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Image.asset(
                              'assets/images/${item['image']}',
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  item['name'] == 'سيارة' ? Icons.directions_car : Icons.motorcycle,
                                  size: 30,
                                  color: customGreen,
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              item['name']!,
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontSize: 16,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selected = val;
                  });
                },
                dropdownColor: Colors.white,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: customGreen,
                ),
                iconSize: 24,
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}