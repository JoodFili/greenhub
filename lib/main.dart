import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:greenhub/screens/ClientHomeScreen.dart';
import 'package:greenhub/screens/PageView.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'utiles/constant_variable.dart' as globals;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  globals.authToken = prefs.getString('token'); // تحميل التوكن إلى المتغير العام
log(globals.authToken.toString());
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

      // ✅ إعدادات التعريب
      locale: const Locale('ar'),
      supportedLocales: const [
        Locale('ar'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: OnboardingPage(), // غيرها حسب ما يناسبك
    );
  }
}
