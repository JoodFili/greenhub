import 'package:flutter/material.dart';
import 'dart:math';
import 'PresentOrder.dart';
import 'PastOrder.dart';
import 'Details.dart';
// import 'HomePage.dart';
// import 'AddFavorate.dart';
// import 'AccountPage.dart';

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


  void navigateToTab(String label) {
    if (label == 'الجديدة') {
      // لا شيء، لأنها الصفحة الحالية
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

  // ✅ دالة للانتقال إلى صفحة التفاصيل
  void navigateToDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Details()), // ✅ افترضي أن اسم صفحة التفاصيل هو DetailsPage
    );
  }

  // ✅ دالة للتنقل في شريط التنقل السفلي
  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    // هنا يمكنك إضافة منطق التنقل بين الصفحات بناءً على الـ index
    // ⚠️ ستحتاجين لاستيراد الصفحات المعنية (HomePage, AddFavorate, AccountPage)
    // مثال:
    // if (index == 0) {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    // } else if (index == 1) { // طلباتي
    //   // لا شيء، لأن هذه الصفحة ضمن قسم طلباتي
    // } else if (index == 2) { // المفضلة
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AddFavorate()));
    // } else if (index == 3) { // حسابي
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountPage()));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: grayColor,
        /// ✅ AppBar مع التابات بداخله
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
          /// ✅ إضافة التابات في الـ bottom من الـ AppBar
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50), // ارتفاع شريط التابات
            child: Container(
              color: Colors.white, // خلفية شريط التابات
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => navigateToTab('الجديدة'),
                    child: tabItem('الجديدة', true, greenColor), // التاب النشط
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
                      // ✅ إضافة مسافة علوية هنا
                      const SizedBox(height: 16), // ✅ مسافة 16 بكسل من الأعلى
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
                            // ✅ إضافة السهم القابل للضغط في أعلى اليمين (في RTL)
                            Align(
                              alignment: Alignment.topLeft, // في RTL، هذا يعني أعلى اليمين
                              child: GestureDetector(
                                onTap: navigateToDetailsPage, // عند الضغط ينتقل لصفحة التفاصيل
                                child: Icon(
                                  Icons.arrow_forward_ios, // رأس السهم يشير لليمين
                                  color: greenColor, // لون السهم
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
                                        //fontFamily: 'Almarai',
                                        color: greenColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Text(
                                      '2025-02-22 4:22 pm',
                                      style: TextStyle(
                                        //fontFamily: 'Almarai'
                                      ),
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
                                //fontFamily: 'Almarai',
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
                            //fontFamily: 'Almarai',
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
        // ✅ شريط التنقل السفلي الجديد
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex, // ✅ تم استخدام currentIndex من الـ State
          onTap: onBottomNavItemTapped, // ✅ تم ربطها بالدالة الجديدة
          selectedItemColor: greenColor, // ✅ تم استخدام greenColor
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed, // ✅ تم إضافة type: fixed
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

  // ✅ دالة tabItem لمساعدة في بناء التابات (موحدة عبر الصفحات)
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
            width: 60, // ✅ تم توحيد العرض إلى 60
            color: selectedColor ?? Colors.black,
          )
      ],
    );
  }

  Widget driverCard(String name, {bool selected = false}) {
    // ✅ منطق عرض النجوم (مثال: 4.5 نجوم)
    List<Widget> starWidgets = [];
    double rating = 4.5; // يمكنك تغيير هذا التقييم
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

    // ✅ توليد سعر عشوائي بين 50 و 200
    Random random = Random();
    int price = random.nextInt(151) + 50; // 151 = (200 - 50) + 1

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
          /// ✅ تم نقل CircleAvatar إلى بداية الـ Row (جهة اليمين في RTL)
          const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.green,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 8), // مسافة بعد الأيقونة
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                //fontFamily: 'Almarai',
                fontSize: 16,
              ),
            ),
          ),
          // ✅ عرض النجوم
          Row(
            children: starWidgets,
          ),
          const SizedBox(width: 8),
          // ✅ عرض السعر وشعار العملة "ر.س"
          Text(
            '$price ر.س',
            style: TextStyle(
              fontFamily: 'Almarai', // استخدام خط Almarai للسعر
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: greenColor,
            ),
          ),
          // ✅ تم إزالة أيقونة العملة القديمة والنصوص '٠'
        ],
      ),
    );
  }
}