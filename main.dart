import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart'; // Add this for modern typography
import 'package:smart_bus_app/busfeepage.dart';

// Your existing imports
import 'package:smart_bus_app/profile.dart';
import 'package:smart_bus_app/provider/provider.dart';
import 'package:smart_bus_app/reportissue.dart';
import 'package:smart_bus_app/screens/homepage.dart' show HomePage;
import 'package:smart_bus_app/setting.dart';
import 'firebase_options.dart';
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/signup.dart';

// NEW IMPORTS for the pages we just built

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const SmartBusApp(),
    ),
  );
}

class SmartBusApp extends StatelessWidget {
  const SmartBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Bus',

      // --- DARK BLUE & WHITE AESTHETIC THEME ---
      theme: ThemeData(
        primaryColor: const Color(0xFF0D1B2A),
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(), // Sets Poppins as default font
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0D1B2A),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/home': (context) => const HomePage(role: ''),

        '/profile': (context) => const ProfilePage(),
        '/fees': (context) => BusFeePage(),
        '/settings': (context) => SettingsPage(),
        '/issue': (context) => ReportIssuePage(),
      },
    );
  }
}