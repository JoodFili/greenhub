import 'package:flutter/material.dart';
import 'location_screen.dart';
import 'NewOrder.dart';
import 'FavoritesPage.dart';
import 'AccountPage.dart';

class shipment_screen extends StatefulWidget {
  @override
  _ShipmentScreenState createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<shipment_screen> {
  String serviceType = "فوري";
  final Color customGreen = const Color(0xFF048372);
  final Color backgroundGray = const Color(0xFFF2F2F2);
  final Color newAmpmColor = const Color(0xFFAECF5C);

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int _selectedIndex = 0;

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: customGreen,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: customGreen),
            ),
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: customGreen,
                onPrimary: Colors.white,
                onSurface: Colors.black,
              ),

              timePickerTheme: TimePickerThemeData(
                dayPeriodColor: newAmpmColor,
                dayPeriodTextColor: Colors.white,
                hourMinuteColor: customGreen,
                hourMinuteTextColor: Colors.white,
                dialHandColor: customGreen,
                dialTextColor: MaterialStateColor.resolveWith((states) {
                  if (states.contains(MaterialState.selected)) {
                    return Colors.white;
                  }
                  return Colors.black;
                }),
                entryModeIconColor: customGreen,
              ),
            ),
            child: child!,
          );
        },
      );
      if (pickedTime != null) {
        setState(() {
          selectedDate = pickedDate;
          selectedTime = pickedTime;
        });
      }
    }
  }

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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'بيانات الشحنة',
            style: TextStyle(color: customGreen, fontFamily: 'Almarai', fontSize: 22),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: customGreen),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          iconTheme: IconThemeData(color: customGreen),
        ),
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildLabeledTextField("الوزن", "٢٠ كغ"),
                  ],
                ),
              ),
              SizedBox(height: 16),

              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildLabeledTextField("النوع", "أثاث"),
                  ],
                ),
              ),
              SizedBox(height: 16),

              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    buildLabeledTextField("الحجم", "كبير"),
                  ],
                ),
              ),
              SizedBox(height: 16),

              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "نوع الخدمة",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Almarai'
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    SizedBox(height: 10),

                    Align(
                      alignment: Alignment.centerRight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildRadio("فوري"),
                          SizedBox(width: 16),
                          buildRadio("مجدول"),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (serviceType == 'مجدول' && selectedDate != null && selectedTime != null)
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "• التاريخ المختار: ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                          style: TextStyle(fontSize: 16, fontFamily: 'Almarai'),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "• الوقت المختار: ${selectedTime!.format(context)}",
                          style: TextStyle(fontSize: 16, fontFamily: 'Almarai'),
                          textAlign: TextAlign.right,
                        ),
                      ),
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
                        MaterialPageRoute(builder: (context) => LocationScreen()),
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
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget buildRadio(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        Radio(
          value: value,
          groupValue: serviceType,
          onChanged: (val) {
            setState(() {
              serviceType = val!;
              if (val == 'مجدول') _selectDateTime();
            });
          },
          activeColor: customGreen,
        ),
        SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontFamily: 'Almarai'),
        ),
      ],
    );
  }
}