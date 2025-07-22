import 'package:flutter/material.dart';

class OrderCard extends StatelessWidget {
  final String number;           // رقم الطلب
  final String date;             // التاريخ / الوقت
  final String status;           // الحالة (قيد التنفيذ، تم التسليم...)
  final Color color;             // لون البطاقة الخلفي
  final bool arrow;              // true = سهم، false = أيقونة حذف
  final VoidCallback? onTap;     // ما يحدث عند الضغط (البطاقة أو زر تفاصيل)
  final VoidCallback? onDelete;  // ما يحدث عند الضغط على حذف (اختياري)

  const OrderCard({
    super.key,
    required this.number,
    required this.date,
    required this.status,
    required this.color,
    this.arrow = false,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // لو البطاقة بيضاء نخلي الأيقونة خضراء، وإلا نخليها بيضاء
    final iconColor = color == Colors.white ? const Color(0xFF048372) : Colors.white;

    // ✅ لون زر التفاصيل ثابت: أخضر فاتح (#96B838)
    const buttonColor = Color(0xFF048372);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF96B838)),
        ),
        color: color,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),

          // زر تفاصيل
          leading: ElevatedButton(
            onPressed: () {
              if (onTap != null) onTap!();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: const Text('تفاصيل'),
          ),

          // العنوان
          title: Text(
            number,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color == Colors.white ? Colors.black : Colors.white,
            ),
          ),

          // السطر الفرعي
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: TextStyle(color: color == Colors.white ? Colors.black : Colors.white),
              ),
              if (status.isNotEmpty)
                Text(
                  status,
                  style: TextStyle(color: color == Colors.white ? Colors.black : Colors.white),
                ),
            ],
          ),

          // سهم أو حذف
          trailing: arrow
              ? Icon(Icons.arrow_forward_ios, color: iconColor, size: 20)
              : IconButton(
            icon: Icon(Icons.delete_outline, color: iconColor),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }
}
