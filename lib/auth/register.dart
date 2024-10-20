import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  bool isPasswordVisible = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
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
                'Registrarse',
                style: TextStyle(
                  fontSize: size.width * 0.05,
                ),
              ),
              SizedBox(height: size.height * 0.02),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.account_circle),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              const TextField(
                decoration: InputDecoration(
                    labelText: 'Correo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              FractionallySizedBox(
                widthFactor: 0.8,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/Home');
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      vertical: size.height * 0.02,
                    ),
                    textStyle: TextStyle(fontSize: size.width * 0.045),
                  ),
                  child: const Text('Registrarse',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Text(
                'O',
                style: TextStyle(
                    fontSize: size.width * 0.045, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: size.height * 0.02),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.g_mobiledata),
                    tooltip: 'Registrarse con Google',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.apple),
                    tooltip: 'Registrarse con Apple',
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Platform.isIOS ? Icons.phone_iphone : Icons.phone,
                    ),
                    tooltip: 'Registrarse con Teléfono',
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.popAndPushNamed(context, '/Login');
                },
                child: Text(
                  '¿Ya tienes una cuenta? Iniciar sesión',
                  style: TextStyle(
                      fontSize: size.width * 0.035,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
