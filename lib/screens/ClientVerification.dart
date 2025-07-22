import 'package:flutter/material.dart';
import 'VerificationCode.dart'; // تأكدي أن اسم الصفحة صح وموجودة

class ClientVerificationPage extends StatefulWidget {
  @override
  _ClientVerificationPageState createState() => _ClientVerificationPageState();
}

class _ClientVerificationPageState extends State<ClientVerificationPage> {
  final TextEditingController phoneController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String selectedCountryCode = '+966';
  final Map<String, String> countryFlags = {
    '+966': 'assets/images/saudii.png',
    '+1': 'assets/images/uae.png',
    '+20': 'assets/images/egypt.png',
  };

  @override
  void dispose() {
    phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _navigateToVerification() {
    String fullNumber = selectedCountryCode + phoneController.text.trim();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerificationCodePage(phoneNumber: fullNumber),
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 200), // تم إرجاع الارتفاع الثابت
                    const Text(
                      'مرحبًا بك في جرين هب',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF048372),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'تسجيل الدخول برقم الجوال',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 15),
                    Focus(
                      onFocusChange: (hasFocus) {
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _focusNode.hasFocus
                                ? const Color(0xFF048372)
                                : Colors.grey, // تم إرجاع اللون الأصلي للحدود
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              countryFlags[selectedCountryCode] ??
                                  'assets/images/saudii.png',
                              width: 30,
                              height: 20,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 8),
                            DropdownButton<String>(
                              value: selectedCountryCode,
                              underline: const SizedBox(),
                              items: countryFlags.keys
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedCountryCode = newValue!;
                                });
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                focusNode: _focusNode,
                                decoration: const InputDecoration(
                                  labelText: 'رقم الجوال',
                                  border: InputBorder.none,
                                  // تم إزالة floatingLabelBehavior: FloatingLabelBehavior.never,
                                ),
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _navigateToVerification,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF048372),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'تحقق',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
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