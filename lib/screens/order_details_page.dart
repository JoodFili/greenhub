import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utiles/constant_variable.dart' as globals;

class OrderDetailsPage extends StatefulWidget {
  final String orderId;
  const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  final TextEditingController _priceCtrl = TextEditingController();

  Map<String, dynamic>? shipmentDetails;
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _fetchShipmentDetails();
  }

  Future<void> _fetchShipmentDetails() async {
    final url = Uri.parse('http://10.0.2.2:8000/api/shipments/${widget.orderId}');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer ${globals.authToken}',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          shipmentDetails = data; // البيانات كاملة
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load shipment details');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء جلب تفاصيل الطلب')),
      );
    }
  }

  @override
  void dispose() {
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendOffer() async {
    if (_priceCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فضلاً أدخل السعر المقترح أولاً')),
      );
      return;
    }

    setState(() => _isSending = true);

    try {
      final url = Uri.parse('http://10.0.2.2:8000/api/offers'); // عدل حسب API الحقيقي

      final response = await http.post(url,
        headers: {
          'Authorization': 'Bearer ${globals.authToken}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'shipment_id': widget.orderId,
          'price': _priceCtrl.text.trim(),
        }),
      );

      if (response.statusCode == 201) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const _OfferSentDialog(),
        );
      } else {
        throw Exception('Failed to send offer');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('فشل في إرسال العرض')),
      );
    } finally {
      setState(() => _isSending = false);
    }
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : shipmentDetails == null
            ? const Center(child: Text('لا توجد تفاصيل لهذا الطلب'))
            : SingleChildScrollView(
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

              // بطاقة التفاصيل مع البيانات الديناميكية
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryGreen, width: 1.4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _detailsTable(shipmentDetails!),
              ),

              const SizedBox(height: 28),

              // السعر المقترح
              Align(
                alignment: Alignment.centerRight,
                child: Text('السعر المقترح:',
                    style: TextStyle(color: Colors.grey.shade800, fontSize: 16)),
              ),
              const SizedBox(height: 6),
              TextField(
                controller: _priceCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: kPrimaryGreen, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: kPrimaryGreen, width: 1.7),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // زر إرسال مع حالة تحميل
              SizedBox(
                width: 150,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6))),
                  onPressed: _isSending ? null : _sendOffer,
                  child: _isSending
                      ? const SizedBox(
                      width: 20,
                      height: 20,
                      child:
                      CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Text('إرسال'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailsTable(Map<String, dynamic> shipmentData) {
    const labelStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.6);
    const valueStyle = TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.6);

    final details = shipmentData['details'] ?? {};

    final labels = [
      'نوع الشحنة:',
      'الحجم:',
      'الوزن:',
      'عنوان الاستلام:',
      'عنوان التوصيل:',
      'تاريخ التوصيل:',
      'وقت التوصيل:',
      'نوع الخدمة:',
      'طريقة الدفع:',
      'ملخص الطلب:',
      'الحالة:',
    ];

    final values = [
      details['type'] ?? '-',
      details['size'] ?? '-',
      details['weight'] ?? '-',
      details['address'] ?? '-',
      details['destination'] ?? '-',
      details['scheduled_date'] ?? '-',
      details['scheduled_time'] ?? '-',
      details['is_immediate'] == true ? 'فوري' : 'مجدول',
      details['payment_method'] ?? '-',
      details['summary'] ?? '-',
      details['status'] ?? '-',
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
}

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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('العودة إلى الرئيسية'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
