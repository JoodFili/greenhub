import 'package:flutter/material.dart';
import 'AddFavorate.dart';

// import 'HomePage.dart';
// import 'NewOrder.dart';
// import 'PresentOrder.dart';
// import 'PastOrder.dart';
// import 'AccountPage.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final Color greenColor = const Color(0xFF048372);
  final Color grayColor = const Color(0xFFF6F6F6);
  int currentIndex = 2; // لأننا في "المفضلة"


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
        ////////////////////////////////////////
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
        ////////////////////////////////////////

//nav bar////////////////////////////////////////////////////////////////////////////
        backgroundColor: grayColor,
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
              const SizedBox(height: 16),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              //   AddFavorate
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AddFavorate()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: greenColor,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('إضافة وجهة مفضلة'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _locationTile(
                        'نقطة الوصول برج مرور حي الصفا - شارع الستين - بجانب مستشفى بشفان',
                      ),
                      const SizedBox(height: 10),
                      _locationTile(
                        'نقطة الوصول برج مرور حي الصفا - شارع الستين - بجانب مستشفى بشفان',
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

  Widget _locationTile(String location) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        border: Border.all(color: greenColor, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              location,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: greenColor, width: 1),
              foregroundColor: greenColor,
            ),
            child: const Text('اختيار'),
          ),
        ],
      ),
    );
  }
}


/*

هذي البار العلوية افضل مع السهم
   appBar: AppBar(
        title: Text('المفضلة'),
        centerTitle: true,
        leading: IconButton(onPressed: (){}, icon: Icon(Icons.arrow_back_ios)),
        // actions: [],

      ),


      لكن في هذي ربط الصفحات كمان
       ElevatedButton(
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => NotificationsPage()),
                            // );
                          },
 */