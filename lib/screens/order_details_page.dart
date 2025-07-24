import 'package:flutter/material.dart';

import 'driver_profile_screen.dart';
import 'driver_home_screen.dart';

class OrderDetailsPage extends StatefulWidget {
  final String orderId; // مثال: 8977
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final TextEditingController _priceCtrl = TextEditingController();

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const kPrimaryGreen = Color(0xFF048372);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('تفاصيل الطلب',
            style: TextStyle(
                color: kPrimaryGreen,
                fontSize: 25,
                fontFamily: 'Almarai',
                fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // رقم الطلب
              Text('#${widget.orderId}',
                  style: const TextStyle(
                      fontSize: 26,
                      color: kPrimaryGreen,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 16),

              // بطاقة التفاصيل
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryGreen, width: 1.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _detailsTable(),
              ),

              const SizedBox(height: 28),

              // السعر المقترح
              Align(
                alignment: Alignment.centerRight,
                child: Text('السعر المقترح:',
                    style:
                        TextStyle(color: Colors.grey.shade800, fontSize: 16)),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _priceCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: kPrimaryGreen, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: kPrimaryGreen, width: 1.7),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // زر إرسال
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: _sendOffer,
                  child: const Text('إرسال'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// يبني العمود اللي داخل البطاقة
  Widget _detailsTable() {
    const labelStyle =
        TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.6);
    const valueStyle =
        TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6);

    // بيانات ثابتة تجريبية – غيّـريها لاحقاً من الـ API
    const labels = [
      'اسم العميل:',
      'عنوان الاستلام:',
      'عنوان التوصيل:',
      'وقت التوصيل:',
      'الوزن:',
      'النوع:',
      'الحجم:',
      'نوع الخدمة:',
      'فئة المركبة:',
      'نوع المركبة:',
      'ملخص الطلب:',
    ];
    const values = [
      'نوفا اسامة',
      'جدة - حي الريان',
      'جدة - حي المطار',
      '8:30 pm',
      '29 kg',
      'أثاث',
      'كبير',
      'فوري',
      'مفتوح',
      'دباب',
      'أريد نقل كتب',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(labels.length, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${labels[i]} ', style: labelStyle),
              Expanded(child: Text(values[i], style: valueStyle)),
            ],
          ),
        );
      }),
    );
  }

  /// عند الضغط على إرسال
  void _sendOffer() {
    if (_priceCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('فضلاً أدخل السعر المقترح أولاً'),
      ));
      return;
    }

    // 🔸 هنا أضيف طلب الـ API لإرسال العرض، وبعد نجاحه:
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _OfferSentDialog(),
    );
  }
}

/// Dialog النجاح
class _OfferSentDialog extends StatelessWidget {
  const _OfferSentDialog();

  @override
  Widget build(BuildContext context) {
    const kPrimaryGreen = Color(0xFF048372);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // أيقونة صح
            const Icon(Icons.verified_rounded, size: 58, color: kPrimaryGreen),
            const SizedBox(height: 14),
            const Text('تم إرسال العرض بنجاح!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 26),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('العودة إلى الرئيسية'),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
                    (route) => false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
