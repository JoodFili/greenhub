import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // مهم جداً
import 'package:greenhub/screens/PageView.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Almarai',
        primaryColor: Colors.green,
      ),

      // ✅ الإعدادات الخاصة بالتعريب
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'), // اللغة العربية فقط
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      //home: shipment_screen(),
      home: OnboardingPage(),

    );
  }
}




