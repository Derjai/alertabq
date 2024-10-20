import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
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
                  '¡Bienvenid@ de vuelta!',
                  style: TextStyle(
                      fontSize: size.width * 0.07, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'Iniciar sesión',
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                  ),
                ),
                SizedBox(height: size.height * 0.05),
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Ingresar correo',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                TextField(
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                      labelText: 'Ingresar contraseña',
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
                      )),
                ),
                SizedBox(height: size.height * 0.02),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('¿Olvidaste tu contraseña?',
                        style: TextStyle(
                            fontSize: size.width * 0.035,
                            fontWeight: FontWeight.bold)),
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
                    child: const Text('Ingresar',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Text(
                  'O',
                  style: TextStyle(
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.g_mobiledata),
                      tooltip: 'Iniciar sesión con Google',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.apple),
                      tooltip: 'Iniciar sesión con Apple',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Platform.isIOS ? Icons.phone_iphone : Icons.phone,
                      ),
                      tooltip: 'Iniciar sesión con Teléfono',
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                TextButton(
                  onPressed: () {
                    Navigator.popAndPushNamed(context, '/Register');
                  },
                  child: Text(
                    '¿No tienes una cuenta? Regístrate',
                    style: TextStyle(
                        fontSize: size.width * 0.035,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
