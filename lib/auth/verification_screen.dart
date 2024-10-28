import 'dart:async';

import 'package:alertabq/auth/auth_service.dart';
import 'package:alertabq/widgets/wrapper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return VerificationScreenState();
  }
}

class VerificationScreenState extends State<VerificationScreen> {
  final AuthService _auth = AuthService();
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _auth.sendEmailVerification();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        _timer.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Wrapper()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(size.width * 0.04),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Text(
              '¡Bienvenid@!',
              style: TextStyle(
                fontSize: size.width * 0.07,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              'Verificación de correo',
              style: TextStyle(
                fontSize: size.width * 0.05,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              'Hemos enviado un correo de verificación a tu dirección de correo electrónico. Por favor, verifica tu correo electrónico para continuar.',
              style: TextStyle(
                fontSize: size.width * 0.04,
              ),
            ),
            SizedBox(height: size.height * 0.05),
            ElevatedButton(
              onPressed: () async {
                await _auth.sendEmailVerification();
              },
              child: const Text('Reenviar enlace'),
            ),
          ],
        ),
      ),
    );
  }
}
