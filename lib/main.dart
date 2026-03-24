import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constants.dart';

import 'screens/onboarding/onboarding_screen.dart';
import 'screens/main_screen_router.dart';

import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyDKbe1hZlsRmomHaLdoBXo2cuvOZg3t9Pc",
        authDomain: "tajpro-ff56d.firebaseapp.com",
        projectId: "tajpro-ff56d",
        storageBucket: "tajpro-ff56d.firebasestorage.app",
        messagingSenderId: "1033555319731",
        appId: "1:1033555319731:web:b43ef15ff5c5e9dedf89c6",
        measurementId: "G-RKR83E3LDW",
      ),
    );
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

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
    final userProvider = Provider.of<UserProvider>(context);

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
      home: !userProvider.isInitialized 
          ? const Scaffold(body: Center(child: CircularProgressIndicator(color: primaryColor)))
          : userProvider.isLoggedIn 
              ? const MainScreenLoader() 
              : const OnboardingScreen(),
    );
  }
}
