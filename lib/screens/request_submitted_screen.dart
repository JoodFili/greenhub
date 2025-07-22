import 'package:flutter/material.dart';
import 'NewOrder.dart';

class RequestSubmittedScreen extends StatelessWidget {
  const RequestSubmittedScreen({super.key});

  static const Color kPrimaryGreen = Color(0xFF048372);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.60),
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.verified_rounded, size: 58, color: kPrimaryGreen),
              const SizedBox(height: 14),
              const Text(
                'تم رفع الطلب بنجاح\nانتظر قبول السائق',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 26),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: const Text('طلباتي'),
                  onPressed: () {

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => NewOrder()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

