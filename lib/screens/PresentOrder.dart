import 'package:flutter/material.dart';
import 'NewOrder.dart';
import 'PastOrder.dart';
import 'Details.dart';
// import 'HomePage.dart';
// import 'AddFavorate.dart';
// import 'AccountPage.dart';

class PresentOrder extends StatefulWidget {
  const PresentOrder({super.key});

  @override
  State<PresentOrder> createState() => _PresentOrderState();
}

class _PresentOrderState extends State<PresentOrder> {
  final Color greenColor = const Color(0xFF048372);
  final Color lightgreen = const Color(0xFFAECF5C);
  final Color grayColor = const Color(0xFFF6F6F6);
  final Color yellowColor = const Color(0xFFFFD600); // أصفر للمجدول
  int currentIndex = 1; // 1 = طلباتي

  void onBottomNavItemTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    // مثال:
    // if (index == 0) {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    // } else if (index == 1) { // طلباتي
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NewOrder())); // أو PresentOrder أو PastOrder
    // } else if (index == 2) { // المفضلة
    //   // لا شيء، لأن هذه الصفحة هي المفضلة
    // } else if (index == 3) { // حسابي
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AccountPage()));
    // }
  }


  //  دالة التنقل بين التابات ////////////////////////////
  void navigateToTab(String label) {
    if (label == 'الجديدة') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const NewOrder()),
      );
    } else if (label == 'الحالية') {
      // لا شيء، لأنها الصفحة الحالية
    } else if (label == 'السابقة') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PastOrder()),
      );
    }
  }
  ////////////////////////////////////////////////////////

  // دالة للانتقال إلى صفحة التفاصيل////////////////////
  void navigateToDetailsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Details()), //  افترضي أن اسم صفحة التفاصيل هو DetailsPage
    );
  }
/////////////////////////////////////////////////////////


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: grayColor,
        ///  AppBar مع التابات بداخله
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
/////////////////appbar- tap///////////////////////////////////////////////////
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
                    child: tabItem('الجديدة', false),
                  ),
                  GestureDetector(
                    onTap: () => navigateToTab('الحالية'),
                    child: tabItem('الحالية', true, greenColor), // التاب النشط
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
///////////////// end appbar\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16), // مسافة الاطراف
                  child: Column(
                    children: [

                      const SizedBox(height: 16), //  مسافة 16 بكسل من الأعلى

                      // =========================================================== كرت 1 =========================
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(30), // حجم المربع ارتفاعه
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: lightgreen, width: 2),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //  (أعلى اليمين في RTL) ويشير لليمين
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: navigateToDetailsPage,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: lightgreen,
                                ),
                              ),
                            ),
                            Text(
                              'قيد التنفيذ',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                color: lightgreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ///
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '#83821',
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.only(top: 8, right: 12),
                                  child: const Text(
                                    '2025-02-22 4:22 pm',
                                    style: TextStyle(
                                      fontFamily: 'Almarai',
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // ==================================================== كرت 2 =================================
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(30), // حجم المربع ارتفاعه
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: lightgreen, width: 2),
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
                                  color: lightgreen, // لون السهم
                                ),
                              ),
                            ),
                            Text(
                              'قيد التنفيذ',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                color: lightgreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ///
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  '#83821',
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    color: Colors.black,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topRight,
                                  padding: const EdgeInsets.only(top: 8, right: 12),
                                  child: const Text(
                                    '2025-02-22 4:22 pm',
                                    style: TextStyle(
                                      fontFamily: 'Almarai',
                                      color: Colors.black,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // ======================================== كرت 3 =======================================================
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(30), // حجم المربع وارتفاعه
                        decoration: BoxDecoration(
                          color: lightgreen, // لون خلفية الكرت
                          borderRadius: BorderRadius.circular(16),
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
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // وسم "مجدول"
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: greenColor, // لون خلفية الوسم
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'مجدول',
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  color: Colors.white, // لون نص الوسم
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            // رقم الطلب والتاريخ
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  '#83822',
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '2025-02-24 3:00 pm',
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // ================================================ كرت 4 =======================
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(30), // حجم المربع وارتفاعه
                        decoration: BoxDecoration(
                          color: lightgreen, // لون خلفية الكرت
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ السهم في مكانه الأصلي (أعلى اليمين في RTL) ويشير لليمين
                            Align(
                              alignment: Alignment.topLeft,
                              child: GestureDetector(
                                onTap: navigateToDetailsPage,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: Colors.white, // لون السهم أبيض ليتناسب مع الخلفية
                                ),
                              ),
                            ),
                            // وسم "مجدول"
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: greenColor, // لون خلفية الوسم
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'مجدول',
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  color: Colors.white, // لون نص الوسم
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 3),
                            // رقم الطلب والتاريخ
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text(
                                  '#83822',
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  '2025-02-24 3:00 pm',
                                  style: TextStyle(
                                    fontFamily: 'Almarai',
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
//nav bar////////////////////////////////////////////////////////////////////////////
        //backgroundColor: grayColor,
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
///////////////////////////////////////////////////////////////////////////////////////
      ),
    );
  }

  //  دالة tabItem لمساعدة في بناء التابات (موحدة عبر الصفحات)
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
            width: 60, // w
            color: selectedColor ?? Colors.black,
          )
      ],
    );
  }
}