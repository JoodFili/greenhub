import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ClientHomeScreen.dart';
import 'driver_home_screen.dart';

class VerificationCodePage extends StatefulWidget {
  final String phoneNumber;
  final String userType;

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
  final dio = Dio();
  final String apiBaseUrl = "http://10.0.2.2:8000/api";

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    await prefs.setString('user_type', widget.userType);
  }

  void _submitCode() async {
    if (verificationCode.length != 6) {
      _showMessage("يرجى إدخال رمز التحقق كاملاً", isError: true);
      return;
    }
    setState(() => isLoading = true);

    try {
      final response = await dio.post(
        "$apiBaseUrl/verify-code",
        data: {
          "phone_number": widget.phoneNumber,
          "code": verificationCode,
          "user_type": widget.userType,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      if (response.data['status'] == true) {
        final token = response.data['token'];
        if (token != null) await saveToken(token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => widget.userType == 'client'
                ? const ClientHomePage()
                : const DriverHomeScreen(),
          ),
        );
      } else {
        _showMessage(response.data['message'] ?? 'رمز التحقق غير صحيح',
            isError: true);
      }
    } catch (e) {
      _showMessage("حدث خطأ أثناء التحقق. تأكد من الاتصال بالسيرفر.",
          isError: true);
    }
    setState(() => isLoading = false);
  }

  void _resendCode() async {
    try {
      await dio.post(
        "$apiBaseUrl/send-code",
        data: {
          "phone_number": widget.phoneNumber,
          "user_type": widget.userType,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      _showMessage("تم إعادة إرسال الرمز");
    } catch (e) {
      _showMessage("تعذر إرسال الرمز. تحقق من الاتصال.", isError: true);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : Colors.green),
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
                    const Text('أدخل رمز التحقق',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF048372))),
                    const SizedBox(height: 20),
                    Text('تم إرسال الرمز على الرقم: ${widget.phoneNumber}',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 20),
                    PinCodeTextField(
                      appContext: context,
                      length: 6,
                      onChanged: (v) => verificationCode = v,
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
                        child: const Text('ما وصلك الرمز؟ إعادة الإرسال',
                            style: TextStyle(color: Color(0xFF048372)))),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isLoading ? null : _submitCode,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF048372),
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 50),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2))
                          : const Text('تحقق',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
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
