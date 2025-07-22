import 'package:flutter/material.dart';
import 'order_card.dart';

class CurrentOrdersPage extends StatelessWidget {
  const CurrentOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const OrderCard(
          number: '#8320',
          date: '2025-02-22 4:22 pm',
          status: 'قيد التنفيذ',
          color: Color(0xFFAECF5C),
        );
      },
    );
  }
}
