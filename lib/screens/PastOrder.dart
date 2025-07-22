import 'package:flutter/material.dart';
import 'NewOrder.dart';
import 'PresentOrder.dart';
import 'Details.dart';
// import 'HomePage.dart';
// import 'AddFavorate.dart';
// import 'AccountPage.dart';

class PastOrder extends StatefulWidget {
  const PastOrder({super.key});

  @override
  State<PastOrder> createState() => _PastOrderState();
}

class _PastOrderState extends State<PastOrder> {
  final Color greenColor = const Color(0xFF048372);
  final Color lightGreen = const Color(0x80AECF5C);
  final Color grayColor = const Color(0xFFF6F6F6);
  int currentIndex = 1;

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
      MaterialPageRoute(
          builder: (context) =>
          const Details()), //  افترضي أن اسم صفحة التفاصيل هو DetailsPage
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
            preferredSize: const Size.fromHeight(50),
            child: Container(
              color: Colors.white,
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
                    child: tabItem('الحالية', false),
                  ),
                  GestureDetector(
                    onTap: () => navigateToTab('السابقة'),
                    child: tabItem('السابقة', true, greenColor), // التاب النشط
                  ),
                ],
              ),
            ),
          ),
        ),
//////////////// end appbar\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      //  إضافة مسافة علوية هنا
                      const SizedBox(height: 16),
                      ...List.generate(5, (index) {
                        //ععد الكروت
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: lightGreen, // لون خلفية الكرت
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
                              const Text(
                                'تم التسليم',
                                style: TextStyle(
                                  fontFamily: 'Almarai',
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '#83820',
                                    style: TextStyle(
                                      fontFamily: 'Almarai',
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(
                                    '2025-02-22 4:22 pm',
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
                        );
                      }),
                    ],
                  ),
                ),
              ),
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
            width: 60,
            color: selectedColor ?? Colors.black,
          )
      ],
    );
  }
}
