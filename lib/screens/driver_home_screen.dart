import 'package:flutter/material.dart';
import 'package:greenhub/screens/PageView.dart';
import 'orders_screen.dart';
import 'notification_screen.dart';
import 'driver_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DriverHomeScreen extends StatelessWidget {
  const DriverHomeScreen({super.key});

  static const Color kPrimaryGreen = Color(0xFF048372);
  static const Color kIconGray = Color(0xFF444444);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: _buildDrawer(context),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: SafeArea(
        child: DefaultTextStyle.merge(
          style: const TextStyle(
              fontFamily: 'Almarai', fontWeight: FontWeight.bold),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(context),
                _buildServicesSection(context),
                _buildOffersSection(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //──────────────── Drawer
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFF8F8F8),
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            color: kPrimaryGreen,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      CircleAvatar(
                        radius: 35,
                        backgroundImage: AssetImage('assets/images/driver.jpg'),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'نوفا أسامة',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _drawerItem(Icons.person_outline, 'حسابي', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const DriverProfileScreen()),
            );
          }),
          _drawerItem(Icons.notifications_none, 'الاشعارات', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NotificationScreen()));
          }),
          _drawerItem(Icons.list_alt_outlined, 'الطلبات', () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const OrdersScreen()));
          }),
          _drawerItem(Icons.account_balance_wallet_outlined, 'المحفظة', () {}),
          const Spacer(),
          const Divider(),
          _drawerItem(Icons.logout, 'الخروج', () async {
            final prefs = await SharedPreferences.getInstance();
            await prefs.remove('token'); // حذف التوكن
            await prefs.remove('userType'); // حذف نوع المستخدم
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => OnboardingPage()),
              (route) => false,
            );
          }, color: Colors.red),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, VoidCallback onTap,
      {Color color = kIconGray}) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 15,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w600,
            color: color),
        textAlign: TextAlign.right,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      trailing: const SizedBox.shrink(),
    );
  }

  //──────────────── Header
  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(height: 240, color: kPrimaryGreen),
        Positioned(
          top: 16,
          left: 16,
          right: 16,
          child: Row(
            children: [
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () => Scaffold.of(context).openDrawer(),
                  child: const Icon(Icons.menu, color: Colors.white, size: 26),
                ),
              ),
              const Spacer(),
              const Text('الصفحة الرئيسية',
                  style: TextStyle(color: Colors.white, fontSize: 25)),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotificationScreen()),
                ),
                child: const Icon(Icons.notifications_none,
                    color: Colors.white, size: 26),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Image.asset('assets/images/car1.png',
              height: 150, fit: BoxFit.contain),
        ),
        const Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  //──────────────── “خدماتك”
  Widget _buildServicesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          const Text('خدماتك',
              textAlign: TextAlign.right, style: TextStyle(fontSize: 32)),
          const SizedBox(height: 4),
          const Text('اختر الخدمة التي تناسبك',
              textAlign: TextAlign.right, style: TextStyle(fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ServiceCard(
                  icon: Icons.emoji_events,
                  title: 'المكافأة',
                  onTap: () {},
                  subtitle1: 'المكافأة',
                  subtitle2: 'استمتع بجمع المكافأت بعد كل توصيلة',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ServiceCard(
                  icon: Icons.all_inbox,
                  title: 'طلبات العملاء',
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const OrdersScreen()));
                  },
                  subtitle1: 'طلبات العملاء',
                  subtitle2: 'اعرض وابدأ بالتوصيل الآن',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //──────────────── “العروض”
  Widget _buildOffersSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('العروض', style: TextStyle(fontSize: 32)),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryGreen, width: 1.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer, color: kPrimaryGreen, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('شارك الرابط الخاص فيك',
                          style: TextStyle(fontSize: 16, color: kPrimaryGreen)),
                      SizedBox(height: 4),
                      Text('واحصل على نقاط مكافأة',
                          style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //──────────────── Bottom Navigation
  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      onTap: (index) {
        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const DriverProfileScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OrdersScreen()),
          );
        }
      },
      selectedItemColor: kPrimaryGreen,
      unselectedItemColor: const Color(0xFF999999),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined), label: 'الرئيسية'),
        BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined), label: 'الطلبات'),
        BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            label: 'المحفظة'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'حسابي'),
      ],
    );
  }
}

//──────────── بطاقة الخدمة المخصصة
class ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback? onTap;
  final String subtitle1;
  final String subtitle2;

  const ServiceCard({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
    required this.subtitle1,
    required this.subtitle2,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF048372).withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(icon, color: const Color(0xFF048372), size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(subtitle1,
                      style: const TextStyle(
                          color: Color(0xFF048372),
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  const SizedBox(height: 2),
                  Text(subtitle2,
                      style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
