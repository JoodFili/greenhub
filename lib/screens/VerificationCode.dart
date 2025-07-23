import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'ClientHomeScreen.dart';
import 'driver_home_screen.dart'; // ✅ استيراد واجهة السائق (تأكد من المسار)

class VerificationCodePage extends StatefulWidget {
  final String phoneNumber;
  final String userType; // 'client' or 'driver'

  const VerificationCodePage({
    super.key,
    required this.phoneNumber,
    required this.userType,
  });

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  String verificationCode = "";
  bool isLoading = false;

  void _submitCode() async {
    if (verificationCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال رمز التحقق كاملاً'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    print("رمز التحقق: $verificationCode");

    if (verificationCode == "123456") {
      Widget nextPage = widget.userType == 'client'
          ? const ClientHomePage()
          : const DriverHomeScreen(); // ✅ حط واجهة السائق الصحيحة هنا

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => nextPage),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('رمز التحقق غير صحيح'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resendCode() {
    print("إعادة إرسال الرمز");
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إعادة إرسال الرمز'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/bb.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 40,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_forward, color: Colors.grey[800]),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 130),
                    const Text(
                      'أدخل رمز التحقق',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF048372),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'تم إرسال الرمز على الرقم: ${widget.phoneNumber}',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (value) => setState(() => verificationCode = value),
                      onCompleted: (value) => verificationCode = value,
                      keyboardType: TextInputType.number,
                      textStyle: const TextStyle(fontSize: 20),
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(8),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeColor: Colors.green,
                        selectedColor: Colors.green.shade700,
                        inactiveColor: Colors.grey.shade400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: _resendCode,
                      child: const Text(
                        'ما وصلك الرمز؟ إعادة الإرسال',
                        style: TextStyle(color: Color(0xFF048372)),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submitCode,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF048372),
                        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text(
                        'تحقق',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
