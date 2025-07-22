import 'package:flutter/material.dart';
// import 'HomePage.dart';
// import 'NewOrder.dart';
// import 'AccountPage.dart';

class AddFavorate extends StatefulWidget {
  const AddFavorate({super.key});

  @override
  State<AddFavorate> createState() => _AddFavorateState();
}

class _AddFavorateState extends State<AddFavorate> {
  final Color greenColor = const Color(0xFF048372);
  final Color grayColor = const Color(0xFFF6F6F6);
  int currentIndex = 2; //  لأننا في "المفضلة"

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

        /// ✅ AppBar الجديد
        appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'المفضلة',
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
//nav bar///////////////////////////////////////////////////////////////////////////
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

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إضافة جهة مفضلة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: 'العنوان',
                  prefixIcon: Icon(Icons.location_on, color: greenColor),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: greenColor),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: greenColor, width: 2),
                  ),
                  fillColor: Colors.white,
                  filled: true,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(color: greenColor),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: const Center(
                  child: Text('خريطة توضيحية',
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: greenColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    child: Text('إضافة', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
