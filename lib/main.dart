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
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print(
      "Could not load .env file, using platform environment if available: $e",
    );
  }

  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: dotenv.env['FIREBASE_API_KEY'] ?? "",
        authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? "",
        projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? "",
        storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? "",
        messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? "",
        appId: dotenv.env['FIREBASE_APP_ID'] ?? "",
        measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? "",
      ),
    );
  } catch (e) {
    print("Firebase initialization failed: $e");
  }

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
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
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            )
          : userProvider.isLoggedIn
          ? const MainScreenLoader()
          : const OnboardingScreen(),
    );
  }
}
