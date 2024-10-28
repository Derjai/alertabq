import 'package:alertabq/app_theme.dart/app_theme.dart';
import 'package:alertabq/auth/landing_page.dart';
import 'package:alertabq/auth/login.dart';
import 'package:alertabq/auth/register.dart';
import 'package:alertabq/auth/verification_screen.dart';
import 'package:alertabq/firebase_options.dart';
import 'package:alertabq/views/home_screen.dart';
import 'package:alertabq/views/my_reports.dart';
import 'package:alertabq/views/profile_screen.dart';
import 'package:alertabq/views/reports.dart';
import 'package:alertabq/views/submit_report.dart';
import 'package:alertabq/widgets/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: AppTheme.lightTheme(),
      darkTheme: AppTheme.darkTheme(),
      themeMode: ThemeMode.system,
      home: const Wrapper(),
      routes: {
        '/Landing': (context) => const LandingPage(),
        '/Login': (context) => const Login(),
        '/Register': (context) => const Register(),
        '/Home': (context) => const HomeScreen(),
        '/Profile': (context) => const ProfileScreen(),
        '/History': (context) => const MyReports(),
        '/Reports': (context) => const Reports(),
        '/SubmitReport': (context) => const SubmitReport(),
        '/Verification': (context) => const VerificationScreen(),
      },
    );
  }
}
