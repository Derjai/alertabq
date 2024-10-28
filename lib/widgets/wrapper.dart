import 'package:alertabq/auth/landing_page.dart';
import 'package:alertabq/auth/verification_screen.dart';
import 'package:alertabq/views/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Algo salió mal'),
              );
            } else {
              if (snapshot.data == null) {
                return const LandingPage();
              } else {
                if (snapshot.data!.emailVerified == true) {
                  return const HomeScreen();
                }
                return const VerificationScreen();
              }
            }
          }),
    );
  }
}
