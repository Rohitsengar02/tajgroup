import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';
import 'screens/main_screen.dart';

import 'screens/onboarding/onboarding_screen.dart';

import 'package:provider/provider.dart';
import 'providers/user_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TajPro CRM ERP',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: bgColor,
        primaryColor: primaryColor,
        brightness: Brightness.light,
        textTheme: GoogleFonts.interTextTheme(),
        canvasColor: surfaceColor,
      ),
      home: const OnboardingScreen(),
    );
  }
}
