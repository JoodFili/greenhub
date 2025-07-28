import 'package:flutter/material.dart';
import 'dart:math';
import 'PresentOrder.dart';
import 'PastOrder.dart';
import 'Details.dart';
import 'ClientHomeScreen.dart';  // تأكد من استيراد الصفحة الرئيسية الصحيحة
import 'AccountPage.dart';
import 'FavoritesPage.dart';    // أو اسم صفحة المفضلة عندك

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
  int currentIndex = 1; // 1 لأن هذه صفحة طلباتي الجديدة حسب ترتيبك

  void navigateToTab(String label) {
    if (label == 'الجديدة') {
      // لا شيء لأنها الصفحة الحالية
    } else if (label == 'الحالية') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PresentOrder()),
      );
    } else if (label == 'السابقة') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PastOrder()),
      );
    }
  }

  void navigateToDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Details()),
    );
  }

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClientHomePage()),
      );
    } else if (index == 1) {
      // هذه الصفحة هي "طلباتي" الجديدة - لا حاجة للتنقل
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FavoritesPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AccountPage()),
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
            onPressed: () {
              Navigator.pop(context);
            },
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
                    child: tabItem('الجديدة', true, greenColor),
                  ),
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
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          border: Border.all(color: greenColor, width: 2),
                          borderRadius: BorderRadius.circular(16),
                          color: whiteColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: navigateToDetailsPage,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: greenColor,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '#83820',
                                      style: TextStyle(
                                        color: greenColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '2025-02-22 4:22 pm',
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.delete_outline, color: greenColor)
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'قيد الانتظار',
                              style: TextStyle(
                                fontSize: 16,
                                color: greenColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      driverCard('احمد محمد', selected: false),
                      driverCard('احمد محمد', selected: true),
                      driverCard('احمد محمد', selected: false),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: greenColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 12),
                          elevation: 2,
                        ),
                        child: const Text(
                          'اختيار السائق',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
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

  Widget driverCard(String name, {bool selected = false}) {
    List<Widget> starWidgets = [];
    double rating = 4.5;
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    for (int i = 0; i < 5; i++) {
      if (i < fullStars) {
        starWidgets.add(Icon(Icons.star, color: Colors.orange, size: 18));
      } else if (i == fullStars && hasHalfStar) {
        starWidgets.add(Icon(Icons.star_half, color: Colors.orange, size: 18));
      } else {
        starWidgets.add(Icon(Icons.star_border, color: Colors.orange, size: 18));
      }
    }

    Random random = Random();
    int price = random.nextInt(151) + 50;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: selected ? lightGreen : whiteColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Row(children: starWidgets),
          const SizedBox(width: 8),
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
    );
  }
}
