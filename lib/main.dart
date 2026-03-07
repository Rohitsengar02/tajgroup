import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TajPro CRM ERP',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme).apply(
          bodyColor: textPrimaryColor,
          displayColor: textPrimaryColor,
        ),
        canvasColor: surfaceColor,
      ),
      home: const MainScreen(),
    );
  }
}
