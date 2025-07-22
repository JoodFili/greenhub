import 'package:flutter/material.dart';
import 'order_card.dart';

class PastOrdersPage extends StatelessWidget {
  const PastOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return const OrderCard(
          number: '#8320',
          date: '2025-02-22 4:22 pm',
          status: 'تم التسليم',
          color: Color(0x80AECF5C),
        );
      },
    );
  }
}