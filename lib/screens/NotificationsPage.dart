import 'package:flutter/material.dart';
import 'package:greenhub/screens/FavoritesPage.dart';
// import 'HomePage.dart';
// import 'NewOrder.dart';
// import 'AccountPage.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final Color greenColor = const Color(0xFF048372);
  final Color grayColor = const Color(0xFFF6F6F6);
  int currentIndex = 0;

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


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: grayColor,
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
        body: SafeArea(
          child: Column(
            children: [
////////////////////////////////////////////
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20),
                color: Colors.white,
                child: Center(
                  child: Text(
                    'الإشعارات',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: greenColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
///////////////////////////////////////////
              ///
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _notificationTile('#83820', 'عرض جديد من السائق'),
                    _notificationTile('#83820', 'تم إصال طلبك'),
                    _notificationTile('#83820', 'تم تأكيد طلبك'),
                    _notificationTile('#83820', 'تم إلغاء طلبك'),
                    _notificationTile(
                      '',
                      'احصل على رمز ترويجي A511 عند طلبك القادم',
                      isPromo: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notificationTile(
      String code,
      String message, {
        bool isPromo = false,
      }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: greenColor),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(
            isPromo ? Icons.settings : Icons.notifications,
            color: greenColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isPromo ? message : '$code\n$message',
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}