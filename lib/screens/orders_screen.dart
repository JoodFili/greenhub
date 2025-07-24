import 'dart:developer';
import 'package:flutter/material.dart';
import 'driver_profile_screen.dart';
import 'new_orders_page.dart';
import 'current_orders_page.dart';
import 'past_orders_page.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('الطلبات',
            style: TextStyle(
                color: Color(0xFF048372),
                fontSize: 25,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF048372),
          unselectedLabelColor: Color(0xFFAECF5C),
          indicatorColor: Color(0xFF048372),
          tabs: const [
            Tab(text: 'الجديدة'),
            Tab(text: 'الحالية'),
            Tab(text: 'السابقة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          NewOrdersPage(),
          CurrentOrdersPage(),
          PastOrdersPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF048372),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
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
      ),
    );
  }
}
