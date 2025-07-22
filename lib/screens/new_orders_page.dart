import 'package:flutter/material.dart';
import 'order_card.dart';
import 'order_details_page.dart';

class NewOrdersPage extends StatelessWidget {
  const NewOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        OrderCard(
          number: '#8977',
          date: '2025-02-22 6:11 am',
          color: Color(0xFFAECF5C),
          arrow: true,
          status: '',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const OrderDetailsPage(orderId: '8977'),
              ),
            );
          },
        ),
      ],
    );
  }
}