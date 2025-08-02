import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'order_card.dart';
import 'order_details_page.dart';
import '../utiles/constant_variable.dart' as globals;

class NewOrdersPage extends StatefulWidget {
  const NewOrdersPage({Key? key}) : super(key: key);

  @override
  State<NewOrdersPage> createState() => _NewOrdersPageState();
}

class _NewOrdersPageState extends State<NewOrdersPage> {
  List<dynamic> orders = [];
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    fetchNewOrders();
  }

  Future<void> fetchNewOrders() async {
    final dio = Dio();
    try {
      final response = await dio.get(
        'http://10.0.2.2:8000/api/driver/new-orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${globals.authToken}',
          },
        ),
      );

      setState(() {
        orders = response.data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = 'حدث خطأ أثناء جلب الطلبات';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الطلبات الجديدة'),
        backgroundColor: const Color(0xFFAECF5C),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error.isNotEmpty
          ? Center(child: Text(error))
          : orders.isEmpty
          ? const Center(child: Text('لا توجد طلبات جديدة'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final details = order['details'];

          // مثلاً نفترض details موجودة وبياناتها:
          final number = '#${order['id']}';
          final date = details != null && details['scheduled_date'] != null
              ? details['scheduled_date']
              : 'غير محدد';
          final color = const Color(0xFFAECF5C);
          final status = details != null ? details['status'] ?? '' : '';

          return OrderCard(
            number: number,
            date: date,
            color: color,
            status: status,
            arrow: true,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OrderDetailsPage(orderId: order['id'].toString()),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
